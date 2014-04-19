Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751737AbaDSVBZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2014 17:01:25 -0400
Received: from mga09.intel.com ([134.134.136.24]:44144 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751251AbaDSVBP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2014 17:01:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,889,1389772800"; 
   d="scan'208";a="496033757"
From: "Gross, Mark" <mark.gross@intel.com>
To: David Cohen <david.a.cohen@linux.intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "x86@kernel.org" <x86@kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gnomes@lxorguk.ukuu.org.uk" <gnomes@lxorguk.ukuu.org.uk>
Subject: RE: [PATCH] MAINTAINERS: INTEL MID SOC: add maintainer
Thread-Topic: [PATCH] MAINTAINERS: INTEL MID SOC: add maintainer
Thread-Index: AQHPWq9q2zoXhvF1CUajSMgkgDop7ZsZb1bg
Date: Sat, 19 Apr 2014 21:01:14 +0000
Message-ID: <BD75D217E5BAC84080F8EFB2582976379C2CFD68@ORSMSX112.amr.corp.intel.com>
References: <1397788758-6335-1-git-send-email-david.a.cohen@linux.intel.com>
In-Reply-To: <1397788758-6335-1-git-send-email-david.a.cohen@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: markgross <mgross@linux.intel.com>

--mgross
The developer experience is our product

> -----Original Message-----
> From: David Cohen [mailto:david.a.cohen@linux.intel.com]
> Sent: Thursday, April 17, 2014 7:39 PM
> To: hpa@zytor.com; mingo@redhat.com; tglx@linutronix.de;
> x86@kernel.org
> Cc: linux-kernel@vger.kernel.org; gnomes@lxorguk.ukuu.org.uk; David
> Cohen; Gross, Mark
> Subject: [PATCH] MAINTAINERS: INTEL MID SOC: add maintainer
> 
> This patch adds official maintainer for low power Intel MID SoC platforms.
> 
> Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
> Cc: Mark Gross <mark.gross@intel.com>
> ---
>  MAINTAINERS | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 6dc67b1fdb50..b6056f33cb4d 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -5447,6 +5447,14 @@ W:	logfs.org
>  S:	Maintained
>  F:	fs/logfs/
> 
> +LOW-POWER INTEL MID SOC SUPPORT
> +M:	David Cohen <david.a.cohen@linux.intel.com>
> +S:	Supported
> +F:	arch/x86/platform/intel-mid/
> +F:	arch/x86/pci/intel_mid_pci.c
> +F:	arch/x86/include/asm/intel-mid.h
> +F:	arch/x86/include/asm/intel_mid*.h
> +
>  LPC32XX MACHINE SUPPORT
>  M:	Roland Stigge <stigge@antcom.de>
>  L:	linux-arm-kernel@lists.infradead.org (moderated for non-
> subscribers)
> --
> 1.9.1

