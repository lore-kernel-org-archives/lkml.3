Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760106Ab3JPHYm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 03:24:42 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:62809 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755174Ab3JPHYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 03:24:41 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Subject: Re: [PATCH v2] pwm: add ep93xx PWM support
Date: Wed, 16 Oct 2013 09:24:36 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-pwm@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>,
        Ryan Mallon <rmallon@gmail.com>, thierry.reding@gmail.com,
        gregkh@linuxfoundation.org
References: <201310151840.03569.hartleys@visionengravers.com>
In-Reply-To: <201310151840.03569.hartleys@visionengravers.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201310160924.36639.arnd@arndb.de>
X-Provags-ID: V02:K0:wRmDgAY3i0CjcVxJGwag8aX9804oVeNsnBplvviZCkc
 Tnt/6Gjxndk6TC8nOnhgtrWaTVi41tJz8eF/ISRiZg/v6kTszR
 wxG4BB27GAPwYBtdTEaBeDOdnMfaI03lYiafgFE5CJjcPohe5r
 8ht0ktSCXkVufjkPRZ/JdIo+C/rFbuD+V3aZDl6VJUSvk+uSne
 60vzClOAuKS9ykrLPYvQNcugLP7IHUHQDv60YJ7YNSTW+6kvHQ
 YVypVPNWmNyr1y2M/UUO+yaS9xGzm6ZyDf97egh7Bzh2aOk/56
 KBWy/FsMXBaa4NX7BBToChal6zeqIPiUwcrML/FHu2Tl0ngLlu
 Te3Zysb61iEfUIa+//Zg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 16 October 2013, H Hartley Sweeten wrote:
> Remove the non-standard EP93xx PWM driver in drivers/misc and add
> a new driver for the PWM controllers on the EP93xx platform based
> on the PWM framework.
> 
> These PWM controllers each support 1 PWM channel with programmable
> duty cycle, frequency, and polarity inversion.
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Ryan Mallon <rmallon@gmail.com>
> Cc: Thierry Reding <thierry.reding@gmail.com>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
> v2: address issues pointed out by Thierry Reding.

Looks all good from my side, thanks for taking up this work.

Acked-by: Arnd Bergmann <arnd@arndb.de>
