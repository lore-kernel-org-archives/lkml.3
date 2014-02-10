Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752216AbaBJEdO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 23:33:14 -0500
Received: from us01smtprelay-2.synopsys.com ([198.182.44.111]:55087 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751849AbaBJEdL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 23:33:11 -0500
X-Greylist: delayed 589 seconds by postgrey-1.27 at vger.kernel.org; Sun, 09 Feb 2014 23:33:11 EST
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: Richard Weinberger <richard@nod.at>
CC: Paul Bolle <pebolle@tiscali.nl>, open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 27/28] Remove ARC_HAS_COH_RTSC
Thread-Topic: [PATCH 27/28] Remove ARC_HAS_COH_RTSC
Thread-Index: AQHPJceR8Td5TdPR/UGwp+tcC5L9vg==
Date: Mon, 10 Feb 2014 04:23:07 +0000
Message-ID: <C2D7FE5348E1B147BCA15975FBA2307517B75D@IN01WEMBXA.internal.synopsys.com>
References: <1391971686-9517-1-git-send-email-richard@nod.at>
 <1391971686-9517-28-git-send-email-richard@nod.at>
Accept-Language: en-US, en-IN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.12.197.80]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Richard,

On Monday 10 February 2014 12:18 AM, Richard Weinberger wrote:
> The symbol is an orphan, get rid of it.
>
> Signed-off-by: Richard Weinberger <richard@nod.at>

Thanks for the cleanup. Applied to ARC for-next.

-Vineet

> ---
>  arch/arc/plat-arcfpga/Kconfig | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/arch/arc/plat-arcfpga/Kconfig b/arch/arc/plat-arcfpga/Kconfig
> index 295cefe..33058aa 100644
> --- a/arch/arc/plat-arcfpga/Kconfig
> +++ b/arch/arc/plat-arcfpga/Kconfig
> @@ -33,7 +33,6 @@ config ISS_SMP_EXTN
>  	bool "ARC SMP Extensions (ISS Models only)"
>  	default n
>  	depends on SMP
> -	select ARC_HAS_COH_RTSC
>  	help
>  	  SMP Extensions to ARC700, in a "simulation only" Model, supported in
>  	  ARC ISS (Instruction Set Simulator).

