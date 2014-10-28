Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751511AbaJ1QSI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 12:18:08 -0400
Received: from mail-ig0-f180.google.com ([209.85.213.180]:46016 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858AbaJ1QSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 12:18:07 -0400
MIME-Version: 1.0
In-Reply-To: <1413539380-7046-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1413539380-7046-1-git-send-email-alexandre.belloni@free-electrons.com>
Date: Tue, 28 Oct 2014 17:17:54 +0100
Message-ID: <CACRpkdbkVXCtaVY1S24bZ-q8vam729p0seGvvpKOL-AQQMywTQ@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: at91: use own header
From: Linus Walleij <linus.walleij@linaro.org>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 17, 2014 at 11:49 AM, Alexandre Belloni
<alexandre.belloni@free-electrons.com> wrote:

> Copy the mach/at91_pio.h header locally and use it for pinctrl-at91.c. This
> allows to remove the dependency on mach/at91_pio.h to be able to move at91 to
> multiplatform.
>
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>

Patch applied to the pinctrl tree with Nicolas' ACK.

Yours,
Linus Walleij
