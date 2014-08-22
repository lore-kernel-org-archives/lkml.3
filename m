Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756177AbaHVMgy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 08:36:54 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:51649 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755956AbaHVMgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 08:36:52 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AkkIAIc491NbdWOb/2dsb2JhbABZgw2BKoJ80SoCAgGBDBZ3hAQBBSMVQRAEBw4KAgImAgJXBhMIiD4Brw+VHheBLI08ZAeCeYFTAQSQfotLlQyDYDsvgQaBSQEBAQ
X-IPAS-Result: AkkIAIc491NbdWOb/2dsb2JhbABZgw2BKoJ80SoCAgGBDBZ3hAQBBSMVQRAEBw4KAgImAgJXBhMIiD4Brw+VHheBLI08ZAeCeYFTAQSQfotLlQyDYDsvgQaBSQEBAQ
X-IronPort-AV: E=Sophos;i="5.04,380,1406584800"; 
   d="scan'208";a="250956531"
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: Re: [PATCH] drivers/ipack/devices/ipoctal.h: Fix typo in include  guard
X-PHP-Originating-Script: 33:rcmail.php
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Fri, 22 Aug 2014 14:36:44 +0200
From: =?UTF-8?Q?Samuel_Iglesias_Gons=C3=A1lvez?= <siglesias@igalia.com>
Cc: Jens Taprogge <jens.taprogge@taprogge.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        industrypack-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Organization: Igalia
In-Reply-To: <1408709363-13361-1-git-send-email-linux@rasmusvillemoes.dk>
References: <1408709363-13361-1-git-send-email-linux@rasmusvillemoes.dk>
Message-ID: <4b63988bb76babf9516c1dbcf38ce463@igalia.com>
User-Agent: Roundcube Webmail/0.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-08-22 14:09, Rasmus Villemoes wrote:
> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> ---
>  drivers/ipack/devices/ipoctal.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/ipack/devices/ipoctal.h 
> b/drivers/ipack/devices/ipoctal.h
> index 28f1c42..7fede0e 100644
> --- a/drivers/ipack/devices/ipoctal.h
> +++ b/drivers/ipack/devices/ipoctal.h
> @@ -12,7 +12,7 @@
>   * Software Foundation; version 2 of the License.
>   */
> 
> -#ifndef _IPOCTAL_H
> +#ifndef _IPOCTAL_H_
>  #define _IPOCTAL_H_
> 
>  #define NR_CHANNELS		8

Acked-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>

Greg, Would you mind picking this patch through your char-misc tree?

Thanks,

Sam
