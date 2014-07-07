Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753163AbaGGP2x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 11:28:53 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:38279 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232AbaGGP2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 11:28:51 -0400
MIME-Version: 1.0
In-Reply-To: <1403523498-3035-1-git-send-email-sachin.kamat@samsung.com>
References: <1403523498-3035-1-git-send-email-sachin.kamat@samsung.com>
Date: Mon, 7 Jul 2014 17:28:50 +0200
Message-ID: <CACRpkdbXH3scLwqbd3OhxfUigGt1FezV2WYagzL3k-ENuKGbGg@mail.gmail.com>
Subject: Re: [PATCH 1/1] pinctrl: bcm281xx: Staticize bcm281xx_pinctrl_probe
From: Linus Walleij <linus.walleij@linaro.org>
To: Sachin Kamat <sachin.kamat@samsung.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sherman Yin <syin@broadcom.com>, spk.linux@gmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2014 at 1:38 PM, Sachin Kamat <sachin.kamat@samsung.com> wrote:

> bcm281xx_pinctrl_probe is local to this file. Make it static.
>
> Signed-off-by: Sachin Kamat <sachin.kamat@samsung.com>

Patch applied.

Yours,
Linus Walleij
