Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758051Ab3E0Lok (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 07:44:40 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:33346 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757954Ab3E0Loj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 07:44:39 -0400
MIME-Version: 1.0
In-Reply-To: <1369402093-27817-1-git-send-email-fabio.baltieri@linaro.org>
References: <1369402093-27817-1-git-send-email-fabio.baltieri@linaro.org>
Date: Mon, 27 May 2013 13:44:38 +0200
Message-ID: <CACRpkdbB7KjzUCf72gqN3ooiWYYkaaPrZUEDeG8HuLk3pTB72A@mail.gmail.com>
Subject: Re: [PATCH] ARM: ux500: select SND_SOC_UX500 for ux500
From: Linus Walleij <linus.walleij@linaro.org>
To: Fabio Baltieri <fabio.baltieri@linaro.org>
Cc: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 24, 2013 at 3:28 PM, Fabio Baltieri
<fabio.baltieri@linaro.org> wrote:

> Enable ux500 specific ALSA SoC drivers by default on u8500_defconfig.
>
> Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>

Thanks, patch applied to my defconfig branch.

Now I can finally use the Snowball board to run sidplay.

Yours,
Linus Walleij
