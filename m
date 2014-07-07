Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752882AbaGGP1P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 11:27:15 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:38365 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752563AbaGGP1L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 11:27:11 -0400
MIME-Version: 1.0
In-Reply-To: <1403576390-28381-1-git-send-email-j@bitron.ch>
References: <1403576390-28381-1-git-send-email-j@bitron.ch>
Date: Mon, 7 Jul 2014 17:27:11 +0200
Message-ID: <CACRpkdb28zErzAur4Op-gh5wp6h3MXYX=2c1u673JyBVqB5udQ@mail.gmail.com>
Subject: Re: [PATCH] gpio: rcar: clamp returned value to [0,1]
From: Linus Walleij <linus.walleij@linaro.org>
To: =?UTF-8?Q?J=C3=BCrg_Billeter?= <j@bitron.ch>
Cc: Alexandre Courbot <gnurou@gmail.com>, Magnus Damm <damm@opensource.se>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 24, 2014 at 4:19 AM, Jürg Billeter <j@bitron.ch> wrote:

> While it will be clamped to bool by gpiolib, let's make this sane
> in the driver as well.
>
> Signed-off-by: Jürg Billeter <j@bitron.ch>

Patch obviously correct to applied.

Yours,
Linus Walleij
