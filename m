Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753566AbaJ1Pl3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 11:41:29 -0400
Received: from mail-ig0-f170.google.com ([209.85.213.170]:39048 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752099AbaJ1Pl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 11:41:28 -0400
MIME-Version: 1.0
In-Reply-To: <1413792260-4265-5-git-send-email-antoine.tenart@free-electrons.com>
References: <1413792260-4265-1-git-send-email-antoine.tenart@free-electrons.com>
	<1413792260-4265-5-git-send-email-antoine.tenart@free-electrons.com>
Date: Tue, 28 Oct 2014 16:41:27 +0100
Message-ID: <CACRpkdYQbz8ZSe-Rt8DfpNnJNbJYONcmxx6M3c5MrYvvNOygOw@mail.gmail.com>
Subject: Re: [PATCH 4/4] pinctrl: berlin: use the generic node to map function
From: Linus Walleij <linus.walleij@linaro.org>
To: Antoine Tenart <antoine.tenart@free-electrons.com>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 20, 2014 at 10:04 AM, Antoine Tenart
<antoine.tenart@free-electrons.com> wrote:

> A generic node to map function has been added into the pinctrl
> framework. It is provieded by GENERIC_PINCONF. Use it in the Berlin
> pinctrl driver as it fits the needs.
>
> Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>

Really nice. Will just apply this with the other stuff in the revised version.

Yours,
Linus Walleij
