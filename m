Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964820AbaE3Otr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 10:49:47 -0400
Received: from mail-by2lp0237.outbound.protection.outlook.com ([207.46.163.237]:45927
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755388AbaE3Otq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 10:49:46 -0400
X-WSS-ID: 0N6E6IU-07-RVC-02
X-M-MSG: 
Message-ID: <53889A75.7060105@amd.com>
Date: Fri, 30 May 2014 09:49:25 -0500
From: Suravee Suthikulanit <suravee.suthikulpanit@amd.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
CC: Jacob Shin <jacob.w.shin@gmail.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, xiakaixu <xiakaixu@huawei.com>
Subject: Re: [PATCH 3/4] perf tools: add hardware breakpoint bp_len test cases
References: <1401377213-24551-1-git-send-email-fweisbec@gmail.com>
 <1401377213-24551-4-git-send-email-fweisbec@gmail.com>
In-Reply-To: <1401377213-24551-4-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428001)(24454002)(199002)(479174003)(189002)(377454003)(64126003)(84676001)(46102001)(83322001)(76176999)(77982001)(65806001)(80022001)(99136001)(59896001)(65956001)(64706001)(47776003)(20776003)(23756003)(86362001)(68736004)(92566001)(80316001)(92726001)(83506001)(33656002)(21056001)(76482001)(77096999)(74502001)(50986999)(87266999)(101416001)(79102001)(85852003)(44976005)(87936001)(97736001)(74662001)(54356999)(99396002)(50466002)(36756003)(83072002)(65816999)(102836001)(31966008)(4396001)(81542001)(81342001);DIR:OUT;SFP:;SCL:1;SRVR:BLUPR02MB194;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: BL:0;ACTION:Default;RISK:Low;SCL:0;SPMLVL:NotSpam;PCL:0;RULEID:
X-Forefront-PRVS: 02272225C5
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/29/2014 10:26 AM, Frederic Weisbecker wrote:
> @@ -1389,6 +1432,21 @@ static struct evlist_test test__events[] = {
>   		.check = test__pinned_group,
>   		.id    = 41,
>   	},
> +	{
> +		.name  = "mem:0/1",
> +		.check = test__checkevent_breakpoint_len,
> +		.id    = 42,
> +	},
> +	{
> +		.name  = "mem:0/2:w",
> +		.check = test__checkevent_breakpoint_len_w,
> +		.id    = 43,
> +	},
> +	{
> +		.name  = "mem:0/4:rw:u",
> +		.check = test__checkevent_breakpoint_len_rw_modifier,
> +		.id    = 44
> +	},
>   #if defined(__s390x__)
>   	{
>   		.name  = "kvm-s390:kvm_s390_create_vm",
Frederic,

This hunk seems to fail to apply on the main tree.  Which tree are you 
working on?

Suravee

