Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759641Ab3BMCGW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 21:06:22 -0500
Received: from na01-bl2-obe.ptr.protection.outlook.com ([65.55.169.30]:5070
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759370Ab3BMCGT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 21:06:19 -0500
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.240.21;KIP:(null);UIP:(null);(null);H:BL2PRD0310HT001.namprd03.prod.outlook.com;R:internal;EFV:INT
X-SpamScore: -1
X-BigFish: PS-1(zz9371I542I1432Izz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahz97hz17326ah8275bh8275dhz31h2a8h668h839h93fhd24hf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h19ceh9a9j1155h)
X-Forefront-Antispam-Report-Untrusted: SFV:SKI;SFS:;DIR:OUT;SFP:;SCL:-1;SRVR:SN2PR03MB061;H:SN2PR03MB061.namprd03.prod.outlook.com;LANG:en;
From: KY Srinivasan <kys@microsoft.com>
To: "mingo@kernel.org" <mingo@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        KY Srinivasan <kys@microsoft.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@linux.intel.com" <hpa@linux.intel.com>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Subject: RE: [tip:x86/hyperv] x86, hyperv: HYPERV depends on X86_LOCAL_APIC
Thread-Topic: [tip:x86/hyperv] x86, hyperv: HYPERV depends on X86_LOCAL_APIC
Thread-Index: AQHOCY3pxY3utlsluUCTO1jjg95ZS5h3CgDw
Date: Wed, 13 Feb 2013 02:05:31 +0000
Message-ID: <b7a851463f4c4846a553307b81bf7b6c@SN2PR03MB061.namprd03.prod.outlook.com>
References: <tip-bc2b0331e077f576369a2b6c75d15ed4de4ef91f@git.kernel.org>
 <tip-cb20e5f2c8d6ba7440a32f4d70c0755bceb36e78@git.kernel.org>
In-Reply-To: <tip-cb20e5f2c8d6ba7440a32f4d70c0755bceb36e78@git.kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [98.110.61.163]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OrganizationHeadersPreserved: SN2PR03MB061.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUTRONIX.DE$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUX.INTEL.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%KERNEL.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%ZYTOR.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14HUBC103.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14HUBC103.redmond.corp.microsoft.com
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(199002)(51704002)(377454001)(189002)(13464002)(15202345001)(4396001)(74502001)(1511001)(50986001)(49866001)(47736001)(59766001)(20776003)(47976001)(63696002)(74662001)(77982001)(50466001)(47776003)(33646001)(23676001)(46102001)(54316002)(56776001)(53806001)(51856001)(44976002)(31966008)(47446002)(54356001)(79102001)(5343635001)(56816002)(5343655001)(16676001)(65816001)(6806001)(66066001)(80022001)(76482001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BY2FFO11HUB020;H:TK5EX14HUBC103.redmond.corp.microsoft.com;RD:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-OriginatorOrg: microsoft.onmicrosoft.com
X-Forefront-PRVS: 07562C22DA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r1D26PwX027238



> -----Original Message-----
> From: tip tree robot [mailto:tipbot@zytor.com] On Behalf Of tip-bot for H. Peter
> Anvin
> Sent: Tuesday, February 12, 2013 8:59 PM
> To: linux-tip-commits@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org; hpa@zytor.com; mingo@kernel.org; KY
> Srinivasan; tglx@linutronix.de; hpa@linux.intel.com
> Subject: [tip:x86/hyperv] x86, hyperv: HYPERV depends on X86_LOCAL_APIC
> 
> Commit-ID:  cb20e5f2c8d6ba7440a32f4d70c0755bceb36e78
> Gitweb:
> http://git.kernel.org/tip/cb20e5f2c8d6ba7440a32f4d70c0755bceb36e78
> Author:     H. Peter Anvin <hpa@linux.intel.com>
> AuthorDate: Tue, 12 Feb 2013 17:46:23 -0800
> Committer:  H. Peter Anvin <hpa@linux.intel.com>
> CommitDate: Tue, 12 Feb 2013 17:46:23 -0800
> 
> x86, hyperv: HYPERV depends on X86_LOCAL_APIC
> 
> In order to compile in the special Hyper-V interrupt vector, we need
> infrastructure in arch/x86/apic/apic.c.  At least for now, simply
> require CONFIG_X86_LOCAL_APIC in order to enable CONFIG_HYPERV.
> 
> Link: http://lkml.kernel.org/r/tip-
> bc2b0331e077f576369a2b6c75d15ed4de4ef91f@git.kernel.org
> Cc: K. Y. Srinivasan <kys@microsoft.com>
> Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
> ---
>  drivers/hv/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/hv/Kconfig b/drivers/hv/Kconfig
> index b38ef6d..64630f1 100644
> --- a/drivers/hv/Kconfig
> +++ b/drivers/hv/Kconfig
> @@ -2,7 +2,7 @@ menu "Microsoft Hyper-V guest support"
> 
>  config HYPERV
>  	tristate "Microsoft Hyper-V client drivers"
> -	depends on X86 && ACPI && PCI
> +	depends on X86 && ACPI && PCI && X86_LOCAL_APIC
>  	help
>  	  Select this option to run Linux as a Hyper-V client operating
>  	  system.
> 
Thank you.

K. Y
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
