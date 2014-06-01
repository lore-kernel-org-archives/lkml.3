Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753252AbaFASHF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 14:07:05 -0400
Received: from mail-bn1blp0190.outbound.protection.outlook.com ([207.46.163.190]:52092
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752397AbaFASHD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 14:07:03 -0400
X-WSS-ID: 0N6I4ZL-08-L8V-02
X-M-MSG: 
Message-ID: <538B6BBF.1020200@amd.com>
Date: Sun, 1 Jun 2014 13:06:55 -0500
From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, Jacob Shin <jacob.w.shin@gmail.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        xiakaixu <xiakaixu@huawei.com>
Subject: Re: [PATCH 0/4] perf: Support AMD range breakpoints
References: <1401377213-24551-1-git-send-email-fweisbec@gmail.com>
 <20140530130627.GB7427@krava.brq.redhat.com>
In-Reply-To: <20140530130627.GB7427@krava.brq.redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428001)(24454002)(189002)(199002)(479174003)(377454003)(51704005)(92726001)(65816999)(65956001)(80022001)(79102001)(92566001)(87936001)(83506001)(86362001)(76176999)(77096999)(50986999)(54356999)(87266999)(46102001)(84676001)(44976005)(83322001)(4396001)(74662001)(99396002)(20776003)(47776003)(64706001)(76482001)(81542001)(77982001)(59896001)(36756003)(81342001)(23756003)(101416001)(83072002)(74502001)(31966008)(97736001)(85852003)(21056001)(50466002)(33656002)(102836001);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR02MB203;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BL:0;ACTION:Default;RISK:Low;SCL:0;SPMLVL:NotSpam;PCL:0;RULEID:
X-Forefront-PRVS: 02296943FF
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have also tested this patch set on the family16h system, and it seems 
to be working okay.  Let me know if I can help with anything else to get 
this patch in.

Suravee

On 05/30/2014 08:06 AM, Jiri Olsa wrote:
> On Thu, May 29, 2014 at 05:26:49PM +0200, Frederic Weisbecker wrote:
>> Hi,
>>
>> I've made it wait too much so I'm posting that for review now. This
>> implements range breakpoints on some AMD machine by extending the length
>> field.
>>
>> Any comment?
> hi,
> perf tools patches look ok to me.. let me know
> if I should queue them
>
> thanks,
> jirka
>
