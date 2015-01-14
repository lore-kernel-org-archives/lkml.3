Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932982AbbANIPf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 03:15:35 -0500
Received: from mail-ig0-f173.google.com ([209.85.213.173]:33922 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932914AbbANIPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 03:15:32 -0500
MIME-Version: 1.0
In-Reply-To: <1419196495-9626-8-git-send-email-wsa@the-dreams.de>
References: <1419196495-9626-1-git-send-email-wsa@the-dreams.de>
	<1419196495-9626-8-git-send-email-wsa@the-dreams.de>
Date: Wed, 14 Jan 2015 09:15:31 +0100
Message-ID: <CACRpkdYNTNzfyamgcjVBBTAre+eSQJPKUKEJej-NrBhXi-iibg@mail.gmail.com>
Subject: Re: [PATCH 07/28] gpio: drop owner assignment from platform_drivers
From: Linus Walleij <linus.walleij@linaro.org>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 21, 2014 at 10:14 PM, Wolfram Sang <wsa@the-dreams.de> wrote:

> This platform_driver does not need to set an owner, it will be populated by the
> driver core.
>
> Signed-off-by: Wolfram Sang <wsa@the-dreams.de>

Patch applied, thanks!

Yours,
Linus Walleij
