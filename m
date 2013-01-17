Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756809Ab3AQK5u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 05:57:50 -0500
Received: from mail-ie0-f177.google.com ([209.85.223.177]:48243 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755725Ab3AQK5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 05:57:42 -0500
MIME-Version: 1.0
In-Reply-To: <1357901029-9073-1-git-send-email-lee.jones@linaro.org>
References: <1357901029-9073-1-git-send-email-lee.jones@linaro.org>
Date: Thu, 17 Jan 2013 11:57:41 +0100
Message-ID: <CACRpkdZhRESXHNVFPzUx7H0ppZ+KSfPOJ2bPS+-CQyv6+8=oZQ@mail.gmail.com>
Subject: Re: [PATCH] ARM: ux500: Include the PRCMU's Secure Registers in
 DB8500's DT
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 11, 2013 at 11:43 AM, Lee Jones <lee.jones@linaro.org> wrote:

> Currently we only include the PRCMU's primary registers when
> referencing the register count in the 'reg' property. This patch
> expands that count to include the secure registers also.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Will you push this to ARM SoC or shall I queue it?

Yours,
Linus Walleij
