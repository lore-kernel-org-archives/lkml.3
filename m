Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755492AbaGIKcq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 06:32:46 -0400
Received: from mail-oa0-f48.google.com ([209.85.219.48]:41696 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753786AbaGIKcp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 06:32:45 -0400
MIME-Version: 1.0
In-Reply-To: <20140707160916.GA9238@himangi-Dell>
References: <20140707160916.GA9238@himangi-Dell>
Date: Wed, 9 Jul 2014 12:32:44 +0200
Message-ID: <CACRpkdbX_mhwOP1S6vLxRi8sqvwk4uo+gLk_0a+2wZOjA_Yoig@mail.gmail.com>
Subject: Re: [PATCH] sh-pfc: sh73a0: Introduce the use of devm_regulator_register
From: Linus Walleij <linus.walleij@linaro.org>
To: Himangi Saraogi <himangi774@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Julia Lawall <julia.lawall@lip6.fr>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 7, 2014 at 6:09 PM, Himangi Saraogi <himangi774@gmail.com> wrote:

> This patch moves data allocated using regulator_register to
> devm_regulator_register and does away the calls to regulator_unregister.
> The sh73a0_pinmux_soc_exit function is no longer needed and is removed.
>
> Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
> Acked-by: Julia Lawall <julia.lawall@lip6.fr>

Laurent is maintaining this driver so let's see if he can ACK it.

Yours,
Linus Walleij
