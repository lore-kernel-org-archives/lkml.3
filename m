Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758155AbaGPKhF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 06:37:05 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:63276 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755967AbaGPKhB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 06:37:01 -0400
Message-ID: <53C655B7.1020506@linaro.org>
Date: Wed, 16 Jul 2014 11:36:39 +0100
From: Daniel Thompson <daniel.thompson@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Russell King <linux@arm.linux.org.uk>
CC: linux-kernel@vger.kernel.org, patches@linaro.org,
        linaro-kernel@lists.linaro.org, Greg Ungerer <gerg@uclinux.org>,
        Arnd Bergmann <arnd.bergmann@linaro.org>
Subject: Re: [PATCH] arm: ks8695: Migrate debug_ll macros to shared directory
References: <1405506667-4649-1-git-send-email-daniel.thompson@linaro.org>
In-Reply-To: <1405506667-4649-1-git-send-email-daniel.thompson@linaro.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/07/14 11:31, Daniel Thompson wrote:
> As part of the migration a couple of uart definitions have been copied
> from of the platform specific header files.
> 
> Note that, in order to keep oldconfig working nicely we must defer the
> removal of arch/arm/mach-ks8695/include/mach/debug-macro.S until
> DEBUG_LL_UART_NONE has been removed.
> 
> Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Greg Ungerer <gerg@uclinux.org>
> Cc: Arnd Bergmann <arnd.bergmann@linaro.org>
> ---
> 
> Notes:
>     This is a contribution towards the removal of DEBUG_LL_UART_NONE, see
>     http://thread.gmane.org/gmane.linux.kernel/1712068/focus=1746065 for
>     details.

Sorry wrong link (focus is not in the most meaningful message). Better
link is:
http://thread.gmane.org/gmane.linux.kernel/1712068/focus=1746366


Daniel.
