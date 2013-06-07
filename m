Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751588Ab3FGHrJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 03:47:09 -0400
Received: from mail-ob0-f172.google.com ([209.85.214.172]:58585 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987Ab3FGHrH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 03:47:07 -0400
MIME-Version: 1.0
In-Reply-To: <1370517676-10909-5-git-send-email-lee.jones@linaro.org>
References: <1370517676-10909-1-git-send-email-lee.jones@linaro.org>
	<1370517676-10909-5-git-send-email-lee.jones@linaro.org>
Date: Fri, 7 Jun 2013 09:47:06 +0200
Message-ID: <CACRpkdYXD527jLzL3m6T6BBRMx+x0u6Wpsas=4se2-EzTb0uqw@mail.gmail.com>
Subject: Re: [PATCH 4/4] ARM: ux500: Remove call to u8500_of_init_devices() - again
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 6, 2013 at 1:21 PM, Lee Jones <lee.jones@linaro.org> wrote:

> Somehow, probably due to a merge error the call to u8500_of_init_devices()
> has re-appeared in next, causing this error:
>
> arch/arm/mach-ux500/cpu-db8500.c: In function ‘u8500_init_machine’:
> arch/arm/mach-ux500/cpu-db8500.c:268:2: error: implicit declaration of     \
>   function ‘u8500_of_init_devices’ [-Werror=implicit-function-declaration]
> arch/arm/mach-ux500/cpu-db8500.c:268:9: warning: assignment makes pointer  \
>   from integer without a cast [enabled by default]
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Looking closer this seems like it's fixing a merge error that appeared in
my linux-stericsson mixdown branch "next" at one point, and which was
fixed three days ago.

The ARM SoC maintainers may need to watch out for that merge error
when pullin in my 5 pull requests sent recently though, that is
essentially the basic merge conflict between the DMA40 and
general devicetree work.

Yours,
Linus Walleij
