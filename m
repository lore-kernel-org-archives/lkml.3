Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906AbbATKHt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 05:07:49 -0500
Received: from mail-ig0-f181.google.com ([209.85.213.181]:54553 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753421AbbATKHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 05:07:44 -0500
MIME-Version: 1.0
In-Reply-To: <1421581173-28416-3-git-send-email-ricardo.ribalda@gmail.com>
References: <1421581173-28416-1-git-send-email-ricardo.ribalda@gmail.com>
	<1421581173-28416-3-git-send-email-ricardo.ribalda@gmail.com>
Date: Tue, 20 Jan 2015 11:07:43 +0100
Message-ID: <CACRpkdaK8dexHkc02uRX-OAzgQ8HtnWou_1qFpcK9VMrwN7Sog@mail.gmail.com>
Subject: Re: [PATCH 2/8] gpio/-mm-lantiq: Use devm_kzalloc
From: Linus Walleij <linus.walleij@linaro.org>
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        John Crispin <blogic@openwrt.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 18, 2015 at 12:39 PM, Ricardo Ribalda Delgado
<ricardo.ribalda@gmail.com> wrote:

> Replace kzalloc with the device managed devm_kzalloc
>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Alexandre Courbot <gnurou@gmail.com>
> Cc: John Crispin <blogic@openwrt.org>
> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>

Patch applied.

Yours,
Linus Walleij
