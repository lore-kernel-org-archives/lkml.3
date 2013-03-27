Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754299Ab3C0NLH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 09:11:07 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:51172 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751972Ab3C0NKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 09:10:50 -0400
MIME-Version: 1.0
In-Reply-To: <201303221210.r2MCA99B031543@localhost.localdomain>
References: <201303221210.r2MCA99B031543@localhost.localdomain>
Date: Wed, 27 Mar 2013 14:10:49 +0100
Message-ID: <CACRpkdbbiTCsCvrB0BME0kkKm7-ZyTiDQLwNNpZ4qNxwZ4z15w@mail.gmail.com>
Subject: Re: [PATCH] MAX7301 GPIO: Do not force SPI speed when using OF Platform
From: Linus Walleij <linus.walleij@linaro.org>
To: Christophe Leroy <christophe.leroy@c-s.fr>
Cc: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        Patrick Vasseur <patrick.vasseur@c-s.fr>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 22, 2013 at 1:10 PM, Christophe Leroy
<christophe.leroy@c-s.fr> wrote:

> The bit_per_word can be set in the OF Device tree, so no need to force it as with
> the platform_data when using OF Platform
>
> Signed-off-by: Patrick Vasseur <patrick.vasseur@c-s.fr>
> Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>

Patch applied.

Thanks!
Linus Walleij
