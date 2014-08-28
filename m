Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751572AbaH1NVF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 09:21:05 -0400
Received: from mail-oi0-f47.google.com ([209.85.218.47]:65102 "EHLO
	mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754AbaH1NVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 09:21:03 -0400
MIME-Version: 1.0
In-Reply-To: <1407755870-439-1-git-send-email-kiran.padwal21@gmail.com>
References: <1407755870-439-1-git-send-email-kiran.padwal21@gmail.com>
Date: Thu, 28 Aug 2014 15:21:02 +0200
Message-ID: <CACRpkdYGtTAwLC40W6Lp9jE1dEumyWuVesvCH2=Ri5K9mqEaJA@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: tegra114: Make of_device_id array const
From: Linus Walleij <linus.walleij@linaro.org>
To: Kiran Padwal <kiran.padwal21@gmail.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 11, 2014 at 1:17 PM, Kiran Padwal <kiran.padwal21@gmail.com> wrote:

> Make of_device_id array const, because all OF functions handle it as const.
>
> Signed-off-by: Kiran Padwal <kiran.padwal21@gmail.com>

Patch applied with Theirry's ACK.

I will squash all of these patches into *one* since it is one single
functional change.

Yours,
Linus Walleij
