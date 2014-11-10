Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753557AbaKJQSG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 11:18:06 -0500
Received: from mail-bl2on0126.outbound.protection.outlook.com ([65.55.169.126]:12896
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751420AbaKJQSD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 11:18:03 -0500
X-WSS-ID: 0NETZXS-08-KLT-02
X-M-MSG: 
Message-ID: <5460E532.9020604@amd.com>
Date: Mon, 10 Nov 2014 10:17:54 -0600
From: Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Borislav Petkov <bp@suse.de>
CC: <a.p.zijlstra@chello.nl>, <paulus@samba.org>, <mingo@redhat.com>,
        <acme@kernel.org>, <tglx@linutronix.de>, <hpa@zytor.com>,
        <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Jan Kiszka" <jan.kiszka@siemens.com>, Len Brown <len.brown@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>
Subject: Re: [PATCH] perf, amd, ibs: Update IBS MSRs and feature definitions
References: <1415291182-4324-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
 <20141106163430.GB4737@pd.tnic> <545BA884.5040406@amd.com>
 <20141108090355.GB14837@pd.tnic> <5460E13B.4090302@amd.com>
 <20141110160345.GB9565@pd.tnic>
In-Reply-To: <20141110160345.GB9565@pd.tnic>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.180.168.240]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(51704005)(377454003)(479174003)(189002)(199003)(24454002)(164054003)(65806001)(92726001)(92566001)(23676002)(120886001)(120916001)(36756003)(97736003)(64706001)(20776003)(21056001)(47776003)(77156002)(62966003)(95666004)(50466002)(76176999)(54356999)(101416001)(105586002)(50986999)(87266999)(106466001)(65816999)(4396001)(99396003)(84676001)(46102003)(59896002)(68736004)(107046002)(31966008)(33656002)(102836001)(44976005)(80316001)(110136001)(86362001)(83506001)(93886004)(87936001);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR02MB196;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR02MB196;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:BLUPR02MB196;
X-Forefront-PRVS: 039178EF4A
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Aravind.Gopalakrishnan@amd.com; 
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:BLUPR02MB196;
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10/2014 10:03 AM, Borislav Petkov wrote:
> On Mon, Nov 10, 2014 at 10:00:59AM -0600, Aravind Gopalakrishnan wrote:
>> No, There aren't any bits in MSR_AMD64_IBS_FETCH_EXTD_CTL that we need to
>> configure right now.
>> So, have included it here mainly to keep the MSR listing consistent with the
>> manual.
> Please remove it then. We put MSRs in msr-index.h which are in use only.
>
>

Ok, Will do.

Thanks,
-Aravind.
