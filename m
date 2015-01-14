Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752555AbbANMdj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 07:33:39 -0500
Received: from mail-ie0-f182.google.com ([209.85.223.182]:49825 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751872AbbANMdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 07:33:37 -0500
MIME-Version: 1.0
In-Reply-To: <1420620297-7329-1-git-send-email-oliver+list@schinagl.nl>
References: <1420620297-7329-1-git-send-email-oliver+list@schinagl.nl>
Date: Wed, 14 Jan 2015 13:33:36 +0100
Message-ID: <CACRpkdYg=bwRtsj8gbxbZnLtg+746xoJQcQf9FdNkhh_poR=PA@mail.gmail.com>
Subject: Re: [PATCH v1] gpio: Make the vararg hacks not pass magic values
From: Linus Walleij <linus.walleij@linaro.org>
To: Olliver Schinagl <oliver+list@schinagl.nl>
Cc: Alexandre Courbot <gnurou@gmail.com>,
        Olliver Schinagl <oliver@schinagl.nl>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 7, 2015 at 9:44 AM, Olliver Schinagl
<oliver+list@schinagl.nl> wrote:

> From: Olliver Schinagl <oliver@schinagl.nl>
>
> Right now, in consumer.h, there's some vararg hacks that pass 0 as the
> flags. What actually is passed however is GPIOD_ASIS, which naturally is
> also 0. Using the define/enum rather then the magic 0 makes it the
> define more readable to a passer by.
>
> Signed-off-by: Olliver Schinagl <oliver@schinagl.nl>

Patch applied.

Yours,
Linus Walleij
