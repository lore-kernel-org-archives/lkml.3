Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754519Ab3AXQGL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 11:06:11 -0500
Received: from mail-oa0-f44.google.com ([209.85.219.44]:49546 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751787Ab3AXQGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 11:06:07 -0500
MIME-Version: 1.0
In-Reply-To: <1354008890-10476-1-git-send-email-lee.jones@linaro.org>
References: <1354008890-10476-1-git-send-email-lee.jones@linaro.org>
Date: Thu, 24 Jan 2013 17:06:06 +0100
Message-ID: <CACRpkdaFwjobNqOLQkk1iOYQotWZ20_LccoghxMETBMmt0f1ew@mail.gmail.com>
Subject: Re: [PATCH 1/1] ARM: ux500: Fix u9540 booting issues
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 27, 2012 at 10:34 AM, Lee Jones <lee.jones@linaro.org> wrote:

> The u9540 stopped booting after the v3.7 merge window due to
> a lack of common clk support and early PRCMU initialisation.
> In this patch we rectify these issues, placing the u9540
> development board back into a successfully booting state.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Applied to my ux500-fixes branch, will go into ARM SoC
pull request RealSoonNow.

Yours,
Linus Walleij
