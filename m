Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933421AbaFINQq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 09:16:46 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:43948 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933279AbaFINQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 09:16:40 -0400
MIME-Version: 1.0
In-Reply-To: <1401445252-21413-1-git-send-email-sachin.kamat@linaro.org>
References: <1401445252-21413-1-git-send-email-sachin.kamat@linaro.org>
Date: Mon, 9 Jun 2014 15:16:40 +0200
Message-ID: <CACRpkdaLBGMJU65_aNZmx63T45yJ8c46coARnHMCXXVoMR+wsg@mail.gmail.com>
Subject: Re: [PATCH 1/1] pinctrl: sunxi: Fix potential null pointer dereference
From: Linus Walleij <linus.walleij@linaro.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 30, 2014 at 12:20 PM, Sachin Kamat <sachin.kamat@linaro.org> wrote:

> kzalloc can fail. Add a null check to avoid null pointer
> dereference error while accessing the pointer later.
>
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>

Patch applied for fixes with Maxime's ACK.

Yours,
Linus Walleij
