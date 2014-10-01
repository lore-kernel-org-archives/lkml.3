Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751582AbaJAKML (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 06:12:11 -0400
Received: from cpsmtpb-ews09.kpnxchange.com ([213.75.39.14]:64782 "EHLO
	cpsmtpb-ews09.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751063AbaJAKMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 06:12:08 -0400
Message-ID: <1412158326.15281.2.camel@x220>
Subject: Re: [PATCH] ARC: [plat-arcfpga]: remove unused Kconfig params
From: Paul Bolle <pebolle@tiscali.nl>
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Cc: vgupta@synopsys.com, richard@nod.at, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org
Date: Wed, 01 Oct 2014 12:12:06 +0200
In-Reply-To: <1412157557-6975-1-git-send-email-michael.opdenacker@free-electrons.com>
References: <1412157557-6975-1-git-send-email-michael.opdenacker@free-electrons.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Oct 2014 10:12:06.0194 (UTC) FILETIME=[273CF920:01CFDD60]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-10-01 at 11:59 +0200, Michael Opdenacker wrote:
> This removes the ARC_BOARD_ANGEL4 and ARC_BOARD_ML509
> Kconfig parameters which are no longer used anywhere
> in the source code and Makefiles.
> 
> This also updates a comment refering to these parameters.
> 
> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
> ---

See commit 774b689502d4 ("ARC: [arcfpga] Get rid of ARC_BOARD_ANGEL4 and
ARC_BOARD_ML509") in linux-next since yesterday.

>  arch/arc/plat-arcfpga/Kconfig | 13 -------------
>  1 file changed, 13 deletions(-)
> 
> diff --git a/arch/arc/plat-arcfpga/Kconfig b/arch/arc/plat-arcfpga/Kconfig
> index b9f34cf55acf..3f6814aa97ac 100644
> --- a/arch/arc/plat-arcfpga/Kconfig
> +++ b/arch/arc/plat-arcfpga/Kconfig
> @@ -12,23 +12,10 @@ menuconfig ARC_PLAT_FPGA_LEGACY
>  	help
>  	  Support for ARC development boards, provided by Synopsys.
>  	  These are based on FPGA or ISS. e.g.
> -	  - ARCAngel4
> -	  - ML509
>  	  - MetaWare ISS

It doesn't follow from the fact that these Kconfig symbols are unused
that this help text is now incorrect. How did you establish that?
 
>  if ARC_PLAT_FPGA_LEGACY
>  
> -config ARC_BOARD_ANGEL4
> -	bool "ARC Angel4"
> -	default y
> -	help
> -	  ARC Angel4 FPGA Ref Platform (Xilinx Virtex Based)
> -
> -config ARC_BOARD_ML509
> -	bool "ML509"
> -	help
> -	  ARC ML509 FPGA Ref Platform (Xilinx Virtex-5 Based)
> -
>  config ISS_SMP_EXTN
>  	bool "ARC SMP Extensions (ISS Models only)"
>  	default n


Paul Bolle

