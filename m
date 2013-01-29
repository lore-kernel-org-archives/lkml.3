Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752124Ab3A2Wl7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 17:41:59 -0500
Received: from mail-ia0-f172.google.com ([209.85.210.172]:60775 "EHLO
	mail-ia0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258Ab3A2Wl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 17:41:57 -0500
MIME-Version: 1.0
In-Reply-To: <1359313332-12305-2-git-send-email-maxime.ripard@free-electrons.com>
References: <1359313332-12305-1-git-send-email-maxime.ripard@free-electrons.com>
	<1359313332-12305-2-git-send-email-maxime.ripard@free-electrons.com>
Date: Tue, 29 Jan 2013 23:41:57 +0100
Message-ID: <CACRpkdZi0zCNf6LDd9UAcd57kFqqWyteVqxL8WfDrFfrt9_5sQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] pinctrl: sunxi: Add of_xlate function
From: Linus Walleij <linus.walleij@linaro.org>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: linux-arm-kernel@lists.infradead.org, Emilio Lopez <emilio@elopez.com.ar>,
        Alejandro Mery <amery@geeks.cl>, Stefan Roese <sr@denx.de>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 27, 2013 at 8:02 PM, Maxime Ripard
<maxime.ripard@free-electrons.com> wrote:

> Since the pin controller of sunxi chips is represented as a single bank
> in the driver.
> Since this is neither convenient nor represented that way in the
> datasheets, define a custom of_xlate function with the layout <bank pin
> flag>
>
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>

This does not apply and I only have 1/3 it seems?

Sorry, help me understand which order these patches go in...

Here is my allwinner branch:
http://git.kernel.org/?p=linux/kernel/git/linusw/linux-pinctrl.git;a=shortlog;h=refs/heads/allwinner-sunxi

Yours,
Linus Walleij
