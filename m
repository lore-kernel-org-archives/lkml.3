Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758700Ab3BVRVf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 12:21:35 -0500
Received: from mail-ie0-f182.google.com ([209.85.223.182]:46923 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758013Ab3BVRVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 12:21:34 -0500
MIME-Version: 1.0
In-Reply-To: <1361547870-32638-1-git-send-email-daniel.lezcano@linaro.org>
References: <1361547870-32638-1-git-send-email-daniel.lezcano@linaro.org>
Date: Fri, 22 Feb 2013 18:21:33 +0100
Message-ID: <CACRpkdYUC4UoZN0ZLcu4S=oma-vd46fbAqQNTFgisG24OPubVA@mail.gmail.com>
Subject: Re: [PATCH] clocksource : nomadik-mtu : fix missing irq initialization
From: Linus Walleij <linus.walleij@linaro.org>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: john.stultz@linaro.org, tglx@linutronix.de, linus.walleij@stericsson.com,
        linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 22, 2013 at 4:44 PM, Daniel Lezcano
<daniel.lezcano@linaro.org> wrote:

> This patch fix the clock device irq field which is not initialized.
>
> Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>

Makes perfect sense:
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Sorry that I might have missed some background here or just be
out-of-track with things, how did this driver work for years without
the irq assigned? Or was this field recently introduced?

Yours,
linus Walleij
