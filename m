Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755095AbaJUKza (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 06:55:30 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:38683 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754940AbaJUKz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 06:55:28 -0400
MIME-Version: 1.0
In-Reply-To: <20141006153736.GB973@ti.com>
References: <CACRpkdb47TFJX=7kEM-D3+HB1JvBe1y+D10ohTqa5D=brp1dfQ@mail.gmail.com>
	<20141006153736.GB973@ti.com>
Date: Tue, 21 Oct 2014 12:55:28 +0200
Message-ID: <CACRpkdYNbhd-cJgXCR2Kb0zSw8+DsuYAVHAKzZOuCtG5316Ahg@mail.gmail.com>
Subject: Re: [RFC PATCH] gpio: add GPIO hogging mechanism
From: Linus Walleij <linus.walleij@linaro.org>
To: Benoit Parrot <bparrot@ti.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 6, 2014 at 5:37 PM, Benoit Parrot <bparrot@ti.com> wrote:

> I do have a modified version of Boris' first patch addressing your original
> comments which I am planning to submit if you it is still a valid idea.

Please do whatever we end up merging or not, sharing code is always
a good idea. Don't forget the device tree bindings.

I have a system of my own (the Nomadik) that needs it can be tested
on.

Yours,
Linus Walleij
