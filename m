Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932191Ab3BGTIR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 14:08:17 -0500
Received: from mail-ia0-f172.google.com ([209.85.210.172]:48143 "EHLO
	mail-ia0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758751Ab3BGTIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 14:08:14 -0500
MIME-Version: 1.0
In-Reply-To: <1360148051-7560-6-git-send-email-lee.jones@linaro.org>
References: <1360148051-7560-1-git-send-email-lee.jones@linaro.org>
	<1360148051-7560-6-git-send-email-lee.jones@linaro.org>
Date: Thu, 7 Feb 2013 20:08:13 +0100
Message-ID: <CACRpkdYyyDuCOPRTLdy_RTad8TqNmBcdvSxpQ1iBr5rqcbC=7Q@mail.gmail.com>
Subject: Re: [PATCH 05/49] ARM: ux500: regulators: Add mask for configuration
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, broonie@opensource.wolfsonmicro.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 6, 2013 at 11:53 AM, Lee Jones <lee.jones@linaro.org> wrote:

> There is already before a register mask in the regulator driver
> to allow some bits of a register to be initialized. The register
> value is defined in the board configuration. This patch puts a
> mask in the board configuration to specify which bits should
> actually be altered. The purpose with this patch is to avoid
> future mistakes when updating the allowed bits in the regulator
> driver.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
