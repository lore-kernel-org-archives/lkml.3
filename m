Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751597Ab3C0Kvi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 06:51:38 -0400
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:63348 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751017Ab3C0Kvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 06:51:36 -0400
Message-ID: <1364381495.1345.21.camel@x61.thuisdomein>
Subject: Re: [PATCH] powerpc: drop even more unused Kconfig symbols
From: Paul Bolle <pebolle@tiscali.nl>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Date: Wed, 27 Mar 2013 11:51:35 +0100
In-Reply-To: <1363864206.1390.117.camel@x61.thuisdomein>
References: <1363864206.1390.117.camel@x61.thuisdomein>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Mar 2013 10:51:35.0566 (UTC) FILETIME=[0D0EB2E0:01CE2AD9]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-03-21 at 12:10 +0100, Paul Bolle wrote:
> diff --git a/arch/powerpc/platforms/wsp/Kconfig b/arch/powerpc/platforms/wsp/Kconfig
> index 79d2225..9eea710 100644
> --- a/arch/powerpc/platforms/wsp/Kconfig
> +++ b/arch/powerpc/platforms/wsp/Kconfig
> @@ -29,7 +29,3 @@ config PPC_CHROMA
>  	default y
>  
>  endmenu
> -
> -config PPC_A2_DD2
> -	bool "Support for DD2 based A2/WSP systems"
> -	depends on PPC_A2

This part was not included in the "powerpc: remove PReP" follow up
patch. Should I resend separately?


Paul Bolle

