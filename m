Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752708AbaE0OD7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 10:03:59 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:52435 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752123AbaE0OD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 10:03:58 -0400
MIME-Version: 1.0
In-Reply-To: <000a01cf7974$fc9fc4d0$f5df4e70$%han@samsung.com>
References: <000a01cf7974$fc9fc4d0$f5df4e70$%han@samsung.com>
Date: Tue, 27 May 2014 16:03:57 +0200
Message-ID: <CACRpkdZgz-XAj8Yfef6pX_t3JF-Kp3PinK2ab3sCS1_vZJ7TgQ@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: berlin: Use devm_ioremap_resource()
From: Linus Walleij <linus.walleij@linaro.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Antoine Tenart <antoine.tenart@free-electrons.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 27, 2014 at 8:29 AM, Jingoo Han <jg1.han@samsung.com> wrote:

> Use devm_ioremap_resource() because devm_request_and_ioremap() is
> obsoleted by devm_ioremap_resource().
>
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>

Patch applied with Antoine's ACK.

Yours,
Linus Walleij
