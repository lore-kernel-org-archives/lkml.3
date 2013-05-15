Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756801Ab3EOTfU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 15:35:20 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:42768 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754709Ab3EOTfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 15:35:18 -0400
MIME-Version: 1.0
In-Reply-To: <1368004193-21213-1-git-send-email-fabio.baltieri@linaro.org>
References: <1368004193-21213-1-git-send-email-fabio.baltieri@linaro.org>
Date: Wed, 15 May 2013 21:35:17 +0200
Message-ID: <CACRpkdZj6r3=fo=72PDshHbL7oHxb6H6uGeGvRyb2+uMjoAvUg@mail.gmail.com>
Subject: Re: [PATCH] ARM: ux500: update MSP1 pinctrl defintions
From: Linus Walleij <linus.walleij@linaro.org>
To: Fabio Baltieri <fabio.baltieri@linaro.org>
Cc: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Lee Jones <lee.jones@linaro.org>,
        Ola Lilja <ola.o.lilja@stericsson.com>,
        Mark Brown <broonie@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 8, 2013 at 11:09 AM, Fabio Baltieri
<fabio.baltieri@linaro.org> wrote:

> Update MSP1 pinctrl definitions in mop500_family_pinmap by removing
> sleep state and setting default ones as pin hogs, as those are used by
> both ux500-msp-i2s.1 and ux500-msp-i2s.3.
>
> Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>

Applied to my ux500-pinctrl branch.

I need to refresh the entire pinctrl setup anyway, so will make
big changes in this file, and need to keep it in my tree.

Yours,
Linus Walleij
