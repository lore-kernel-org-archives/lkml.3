Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751979Ab3IQBoc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 21:44:32 -0400
Received: from outbound-mail03.westnet.com.au ([203.10.1.244]:49683 "EHLO
	outbound-mail03.westnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751778Ab3IQBob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 21:44:31 -0400
X-Greylist: delayed 6974 seconds by postgrey-1.27 at vger.kernel.org; Mon, 16 Sep 2013 21:44:30 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApMBAM+XN1KVhxBY/2dsb2JhbAANTsUWgTWDGQEBAQR4ARALGAkWDwkDAgECAUUGDQEFAgEBh2wBp2mTC49zB4QeA60l
X-IronPort-AV: E=Sophos;i="4.90,919,1371052800"; 
   d="scan'208";a="359346354"
X-WN-REMOTEIP: 149.135.16.88
X-WN-ENVELOPESENDER: gregungerer@westnet.com.au
X-WN-MID: 359346354
X-WN-SMTPAUTHID: gregungerer
Message-ID: <523798BD.9010108@westnet.com.au>
Date: Tue, 17 Sep 2013 09:48:13 +1000
From: Greg Ungerer <gregungerer@westnet.com.au>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>
CC: geert@linux-m68k.org, linux-m68k@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] m68k: remove unused Kconfig parameters
References: <1378468779-3289-1-git-send-email-michael.opdenacker@free-electrons.com>
In-Reply-To: <1378468779-3289-1-git-send-email-michael.opdenacker@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael,

On 06/09/13 21:59, Michael Opdenacker wrote:
> This patch proposes to remove the UC5282 and UC5272 kernel configuration
> parameters defined in arch/m68k/Kconfig.machine,
> but used nowhere in the makefiles and source code.
> 
> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>

This change is a subset of c065edde ("remove 16 unused boards in
Kconfig.machine") by Pauk Bolle. And that is in 3.12-rc1.

Thanks
Greg



> ---
>  arch/m68k/Kconfig.machine | 12 ------------
>  1 file changed, 12 deletions(-)
> 
> diff --git a/arch/m68k/Kconfig.machine b/arch/m68k/Kconfig.machine
> index b9ab0a6..a10516b 100644
> --- a/arch/m68k/Kconfig.machine
> +++ b/arch/m68k/Kconfig.machine
> @@ -150,18 +150,6 @@ config XCOPILOT_BUGS
>  	help
>  	  Support the bugs of Xcopilot.
>  
> -config UC5272
> -	bool "Arcturus Networks uC5272 dimm board support"
> -	depends on M5272
> -	help
> -	  Support for the Arcturus Networks uC5272 dimm board.
> -
> -config UC5282
> -	bool "Arcturus Networks uC5282 board support"
> -	depends on M528x
> -	help
> -	  Support for the Arcturus Networks uC5282 dimm board.
> -
>  config UCSIMM
>  	bool "uCsimm module support"
>  	depends on M68EZ328
> 

