Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932982Ab3ECI1M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 04:27:12 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:39962 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018Ab3ECI1K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 04:27:10 -0400
MIME-Version: 1.0
In-Reply-To: <1367509690-24022-2-git-send-email-lee.jones@linaro.org>
References: <1367509690-24022-1-git-send-email-lee.jones@linaro.org>
	<1367509690-24022-2-git-send-email-lee.jones@linaro.org>
Date: Fri, 3 May 2013 10:27:09 +0200
Message-ID: <CACRpkdacXK-uBsQF=VGfOvh_zZ3ad-A_Zk1Bd-oz+OAUTeXqHA@mail.gmail.com>
Subject: Re: [PATCH 1/4] ARM: ux500: Rid ignored return value of
 regulator_enable() compiler warning
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

On Thu, May 2, 2013 at 5:48 PM, Lee Jones <lee.jones@linaro.org> wrote:

> arch/arm/mach-ux500/board-mop500.c: In function ‘mop500_prox_activate’:
> arch/arm/mach-ux500/board-mop500.c:406:18: warning: ignoring return value of
>         ‘regulator_enable’, declared with attribute warn_unused_result
>         [-Wunused-result]
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Applied!

Thanks,
Linus Walleij
