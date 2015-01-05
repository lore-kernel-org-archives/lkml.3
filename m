Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753190AbbAEDMN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2015 22:12:13 -0500
Received: from mail-by2on0057.outbound.protection.outlook.com ([207.46.100.57]:30033
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752854AbbAEDMM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2015 22:12:12 -0500
X-Greylist: delayed 1962 seconds by postgrey-1.27 at vger.kernel.org; Sun, 04 Jan 2015 22:12:11 EST
From: "Zhang, Sonic" <Sonic.Zhang@analog.com>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Steven Miao <realmz6@gmail.com>,
        "adi-buildroot-devel@lists.sourceforge.net" 
	<adi-buildroot-devel@lists.sourceforge.net>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [Adi-buildroot-devel] [PATCH] arch: blackfin: kernel: kgdb:
 Remove	unused function
Thread-Topic: [Adi-buildroot-devel] [PATCH] arch: blackfin: kernel: kgdb:
 Remove	unused function
Thread-Index: AQHQJeuZbiwGu1D+20GpMjFNQAiNvpyw1O0Q
Date: Mon, 5 Jan 2015 02:38:10 +0000
Message-ID: <B168F8A49F4BCF4C84FD23DA5F6363EE61213551@NWD2MBX7.ad.analog.com>
References: <1420134867-1594-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
In-Reply-To: <1420134867-1594-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.99.90.25]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
Authentication-Results: spf=pass (sender IP is 137.71.25.57)
 smtp.mailfrom=Sonic.Zhang@analog.com; 
X-Forefront-Antispam-Report: CIP:137.71.25.57;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(189002)(199003)(13464003)(13624006)(51704005)(377454003)(107046002)(76176999)(86362001)(50986999)(92566001)(4396001)(97756001)(106116001)(106466001)(21056001)(50466002)(33656002)(54356999)(16796002)(31966008)(102836002)(55846006)(2920100001)(2900100001)(99396003)(23726002)(64706001)(20776003)(47776003)(2656002)(87936001)(46406003)(19580395003)(6806004)(19580405001)(230783001)(2950100001)(46102003)(120916001)(15975445007)(62966003)(77156002)(16601075003)(587094005);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2PR03MB227;H:nwd2mta2.analog.com;FPR:;SPF:Pass;MLV:sfv;PTR:nwd2mail11.analog.com;MX:1;A:1;LANG:en;
X-DmarcAction: None
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005003);SRVR:BL2PR03MB227;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BL2PR03MB227;
X-Forefront-PRVS: 0447DB1C71
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BL2PR03MB227;
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2015 02:39:24.6829
 (UTC)
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.57]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL2PR03MB227
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Sonic Zhang <sonic.zhang@analog.com>

Sonic

>-----Original Message-----
>From: Rickard Strandqvist [mailto:rickard_strandqvist@spectrumdigital.se]
>Sent: Friday, January 02, 2015 1:54 AM
>To: Steven Miao; adi-buildroot-devel@lists.sourceforge.net
>Cc: linux-kernel@vger.kernel.org; Rickard Strandqvist
>Subject: [Adi-buildroot-devel] [PATCH] arch: blackfin: kernel: kgdb: Remove unused function
>
>Remove the function kgdb_post_primary_code() that is not used anywhere.
>
>This was partially found by using a static code analysis program called cppcheck.
>
>Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
>---
> arch/blackfin/kernel/kgdb.c |   13 -------------
> 1 file changed, 13 deletions(-)
>
>diff --git a/arch/blackfin/kernel/kgdb.c b/arch/blackfin/kernel/kgdb.c index fa53fae..b1cc04f 100644
>--- a/arch/blackfin/kernel/kgdb.c
>+++ b/arch/blackfin/kernel/kgdb.c
>@@ -359,19 +359,6 @@ void kgdb_roundup_cpu(int cpu, unsigned long flags)  static unsigned long kgdb_arch_imask;  #endif
>
>-void kgdb_post_primary_code(struct pt_regs *regs, int e_vector, int err_code) -{
>-	if (kgdb_single_step)
>-		preempt_enable();
>-
>-#ifdef CONFIG_IPIPE
>-	if (kgdb_arch_imask) {
>-		cpu_pda[raw_smp_processor_id()].ex_imask = kgdb_arch_imask;
>-		kgdb_arch_imask = 0;
>-	}
>-#endif
>-}
>-
> int kgdb_arch_handle_exception(int vector, int signo,
> 			       int err_code, char *remcom_in_buffer,
> 			       char *remcom_out_buffer,
>--
>1.7.10.4
>
>
>------------------------------------------------------------------------------
>Dive into the World of Parallel Programming! The Go Parallel Website,
>sponsored by Intel and developed in partnership with Slashdot Media, is your
>hub for all things parallel software development, from weekly thought
>leadership blogs to news, videos, case studies, tutorials and more. Take a
>look and join the conversation now. http://goparallel.sourceforge.net
>_______________________________________________
>Adi-buildroot-devel mailing list
>Adi-buildroot-devel@lists.sourceforge.net
>https://lists.sourceforge.net/lists/listinfo/adi-buildroot-devel

