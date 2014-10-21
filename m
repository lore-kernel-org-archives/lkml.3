Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754505AbaJUIwQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 04:52:16 -0400
Received: from mail-ig0-f174.google.com ([209.85.213.174]:56094 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751824AbaJUIwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 04:52:13 -0400
MIME-Version: 1.0
In-Reply-To: <1412160393-5848-1-git-send-email-pramod.gurav@smartplayin.com>
References: <1412160393-5848-1-git-send-email-pramod.gurav@smartplayin.com>
Date: Tue, 21 Oct 2014 10:52:12 +0200
Message-ID: <CACRpkdZ1XM4ztKBO1aKWmFtQHp+6j9jJL8wuPVJ2mvQWR2cM5A@mail.gmail.com>
Subject: Re: [PATCH] gpio: Switch to using managed resources with devm_
From: Linus Walleij <linus.walleij@linaro.org>
To: Pramod Gurav <pramod.gurav@smartplayin.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 1, 2014 at 12:46 PM, Pramod Gurav
<pramod.gurav@smartplayin.com> wrote:

> This change switches to devm_request_region to request region
> and hence simplifies the module unload and does away with
> release_region in remove function.
>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Alexandre Courbot <gnurou@gmail.com>
> Cc: linux-gpio@vger.kernel.org
> Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>

Patch applied with augmented subject.

Yours,
Linus Walleij
