Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932683AbaEPNhQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 09:37:16 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:36341 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932642AbaEPNhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 09:37:09 -0400
MIME-Version: 1.0
In-Reply-To: <1399978733-13662-3-git-send-email-k.kozlowski@samsung.com>
References: <1399978733-13662-1-git-send-email-k.kozlowski@samsung.com>
	<1399978733-13662-3-git-send-email-k.kozlowski@samsung.com>
Date: Fri, 16 May 2014 15:37:08 +0200
Message-ID: <CACRpkdZfSgd89zCegj2s7gHqUwG8O+vDiyS3BLTiJmFo7TL-Pg@mail.gmail.com>
Subject: Re: [PATCH 03/16] mfd: ipaq-micro: Make mfd_cell array const
From: Linus Walleij <linus.walleij@linaro.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2014 at 12:58 PM, Krzysztof Kozlowski
<k.kozlowski@samsung.com> wrote:

> mfd_add_devices() expects array of struct mfd_cell to be const.
>
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> Cc: Linus Walleij <linus.walleij@linaro.org>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
