Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752203AbaLBJgp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 04:36:45 -0500
Received: from mail-bl2on0099.outbound.protection.outlook.com ([65.55.169.99]:64534
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750964AbaLBJgn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 04:36:43 -0500
Date: Tue, 2 Dec 2014 10:36:28 +0100
From: Michal Simek <michal.simek@xilinx.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Prabhakar Lad <prabhakar.csengg@gmail.com>,
        Michal Simek <michal.simek@xilinx.com>
CC: LKML <linux-kernel@vger.kernel.org>, <monstr@monstr.eu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Laura Abbott <lauraa@codeaurora.org>, Olof Johansson <olof@lixom.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
Subject: Re: [PATCH v1] lib/genalloc.c: Export devm_gen_pool_create for modules
References: <2e3f47e730975654f9b6c888a07db6c3f886b892.1417438852.git.michal.simek@xilinx.com>
 <CA+V-a8vw2d8H=Qx99M4oXqUatt5wmePVW82ARdMcWLEVLXbZJw@mail.gmail.com>
In-Reply-To: <CA+V-a8vw2d8H=Qx99M4oXqUatt5wmePVW82ARdMcWLEVLXbZJw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21144.006
X-TM-AS-User-Approved-Sender: Yes
Message-ID: <522b42cef4da41d48e81d99bc8e447a8@BL2FFO11FD047.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:62.221.5.235;CTRY:GB;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(51914003)(164054003)(189002)(199003)(479174003)(377454003)(51704005)(24454002)(19580405001)(92566001)(19580395003)(74316001)(46102003)(65956001)(87936001)(104016003)(20776003)(47776003)(107046002)(120916001)(108616004)(6806004)(44976005)(50466002)(62966003)(77156002)(64126003)(23676002)(102836001)(86362001)(50986999)(106466001)(4396001)(99396003)(21056001)(83506001)(54356999)(95666004)(76176999)(31966008)(65826006)(107986001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2FFO11HUB015;H:xir-pvapsmtpgw01;FPR:;SPF:Pass;MLV:sfv;PTR:unknown-62-221-5-235.ipspace.xilinx.com;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BL2FFO11HUB015;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BL2FFO11HUB015;
X-Forefront-PRVS: 0413C9F1ED
Authentication-Results: spf=pass (sender IP is 62.221.5.235)
 smtp.mailfrom=michal.simek@xilinx.com; 
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BL2FFO11HUB015;
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/02/2014 10:31 AM, Prabhakar Lad wrote:
> Hi Michal,
> 
> Thanks for the patch.
> 
> On Mon, Dec 1, 2014 at 1:00 PM, Michal Simek <michal.simek@xilinx.com> wrote:
>> Modules can use this function for creating pool.
>>
>> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
>> ---
>>
>> I am pushing Zynq OCMC driver which is using this function.
>>
>> ---
>>  lib/genalloc.c | 1 +
>>  1 file changed, 1 insertion(+)
>>
> don’t you need to add an entry in include/linux/genalloc.h ?

Not sure what exactly you mean. declaration is there.
include/linux/genalloc.h:120:extern struct gen_pool *devm_gen_pool_create(struct device *dev,

And all EXPORT_SYMBOL() are out of headers directly below function
which you want to export.

Can you please clarify what you did mean by that?

Thanks,
Michal
