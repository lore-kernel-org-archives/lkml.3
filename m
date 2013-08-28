Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754967Ab3H1LPZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 07:15:25 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:42003 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752675Ab3H1LPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 07:15:23 -0400
MIME-Version: 1.0
In-Reply-To: <1377153008.18701.0.camel@phoenix>
References: <1377153008.18701.0.camel@phoenix>
Date: Wed, 28 Aug 2013 13:15:22 +0200
Message-ID: <CACRpkdZR1JdhDOcWPCEAXgug1kfMZvAAsYwvWbWyLK7_jEyNvA@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: palmas: PINCTRL_PALMAS needs to select PINMUX
From: Linus Walleij <linus.walleij@linaro.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Laxman Dewangan <ldewangan@nvidia.com>, Lee Jones <lee.jones@linaro.org>,
        Stephen Warren <swarren@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 22, 2013 at 8:30 AM, Axel Lin <axel.lin@ingics.com> wrote:

> Fix below build error if !PINMUX.
>
>   CC      drivers/pinctrl/pinctrl-palmas.o

Patch applied with Laxman's ACK.

Yours,
Linus Walleij
