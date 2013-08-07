Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932852Ab3HGSVO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 14:21:14 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:61846 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932194Ab3HGSVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 14:21:13 -0400
MIME-Version: 1.0
In-Reply-To: <1375085972-657-1-git-send-email-sachin.kamat@linaro.org>
References: <1375085972-657-1-git-send-email-sachin.kamat@linaro.org>
Date: Wed, 7 Aug 2013 20:21:13 +0200
Message-ID: <CACRpkdbk8BCViQz0d+0Ok4wVvTDK_TRN0UTc1nyC7G48A-C-WA@mail.gmail.com>
Subject: Re: [PATCH 1/1] pinctrl: sunxi: Fix incorrect NULL check
From: Linus Walleij <linus.walleij@linaro.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 29, 2013 at 10:19 AM, Sachin Kamat <sachin.kamat@linaro.org> wrote:

> *map should be tested for NULL instead of map as kmalloc pointer
> is assigned to it. This also fixes a potential null pointer dereference
> bug later in the code.
>
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> Cc: Maxime Ripard <maxime.ripard@free-electrons.com>

Patch applied with Maxime's ACK.

Yours,
Linus Walleij
