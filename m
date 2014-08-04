Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752516AbaHDT2a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 15:28:30 -0400
Received: from mail-bn1lp0141.outbound.protection.outlook.com ([207.46.163.141]:37453
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752227AbaHDT22 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 15:28:28 -0400
X-WSS-ID: 0N9SREO-08-9MM-02
X-M-MSG: 
Message-ID: <53DFDEB7.1090307@amd.com>
Date: Mon, 4 Aug 2014 14:27:51 -0500
From: Suravee Suthikulanit <suravee.suthikulpanit@amd.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@gmail.com>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Jacob Shin <jacob.w.shin@gmail.com>,
        "Arnaldo Carvalho de Melo" <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, xiakaixu <xiakaixu@huawei.com>,
        Anne Mascarin <amascari@redhat.com>
Subject: Re: [PATCH 2/4] perf tools: allow user to specify hardware breakpoint
 bp_len
References: <1401377213-24551-1-git-send-email-fweisbec@gmail.com>
 <1401377213-24551-3-git-send-email-fweisbec@gmail.com>
 <20140530133906.GC7427@krava.brq.redhat.com>
 <87mwduepux.fsf@sejong.aot.lge.com>
 <20140603115503.GA2864@krava.brq.redhat.com> <5391EC92.8040500@amd.com>
In-Reply-To: <5391EC92.8040500@amd.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428002)(164054003)(199002)(189002)(24454002)(479174003)(377454003)(51704005)(74502001)(46102001)(21056001)(74662001)(92726001)(92566001)(85306004)(99396002)(47776003)(20776003)(81542001)(106466001)(84676001)(97736001)(65816999)(15202345003)(54356999)(19580405001)(80316001)(50986999)(83322001)(76482001)(50466002)(87266999)(86362001)(31966008)(85852003)(19580395003)(83072002)(107046002)(575784001)(87936001)(36756003)(76176999)(93886004)(23756003)(33656002)(102836001)(64126003)(101416001)(64706001)(59896001)(80022001)(79102001)(65956001)(105586002)(77982001)(4396001)(95666004)(81342001)(68736004)(83506001)(15975445006);DIR:OUT;SFP:;SCL:1;SRVR:CO1PR02MB048;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 0293D40691
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic,

3.17 windows is now open. Do you think you could get this one in?

Thanks

Suravee

On 6/6/2014 11:30 AM, Suravee Suthikulanit wrote:
> This message has been archived. View the original item
> <http://ausev2.amd.com/EnterpriseVault/ViewMessage.asp?VaultId=1C7248B8A7CDE234D884C352F0CB2021B1110000amdvault.amd.com&SavesetId=201407115122720~201406061630160000~Z~F134EBF86540766B73DA6ADB45060FE1>
> On 6/3/2014 6:55 AM, Jiri Olsa wrote:
>  > On Tue, Jun 03, 2014 at 10:36:22AM +0900, Namhyung Kim wrote:
>  >> Hi Jiri,
>  >>
>  >> On Fri, 30 May 2014 15:39:06 +0200, Jiri Olsa wrote:
>  >>> On Thu, May 29, 2014 at 05:26:51PM +0200, Frederic Weisbecker wrote:
>  >>>> From: Jacob Shin <jacob.w.shin@gmail.com>
>  >>>>
>  >>>> Currently bp_len is given a default value of 4. Allow user to
> override it:
>  >>>>
>  >>>>    $ perf stat -e mem:0x1000/8
>  >>>>                              ^
>  >>>>                              bp_len
>  >>>>
>  >>>> If no value is given, it will default to 4 as it did before.
>  >>>
>  >>> Namhyung,
>  >>> both perf tols patches from this patchset mess up with hists
>  >>> tests..  I havent found any connection yet.. any idea? ;-)
>  >>
>  >> So you already found the problem in the hpp->elide change and that's the
>  >> reason of the failure, right? :)
>  >
>  > I haven't got a chance to test it yet.. but it looks like
>  > thats the case.. I'll retest soon ;-)
>  >
>  > jirka
>  >
> Anything I can do to help here?
>
> Thanks,
>
> Suravee
>


