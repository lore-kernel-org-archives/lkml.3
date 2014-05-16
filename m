Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757449AbaEPNhp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 09:37:45 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:64648 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756622AbaEPNhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 09:37:39 -0400
MIME-Version: 1.0
In-Reply-To: <1399978733-13662-4-git-send-email-k.kozlowski@samsung.com>
References: <1399978733-13662-1-git-send-email-k.kozlowski@samsung.com>
	<1399978733-13662-4-git-send-email-k.kozlowski@samsung.com>
Date: Fri, 16 May 2014 15:37:38 +0200
Message-ID: <CACRpkdaxeW55Aqwfst1Z3YjZ2uh1M5ZaH0rPhPxKe+6nd599sQ@mail.gmail.com>
Subject: Re: [PATCH 04/16] mfd: db8500-prcmu: Make mfd_cell array const
From: Linus Walleij <linus.walleij@linaro.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mattias Nilsson <mattias.i.nilsson@stericsson.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2014 at 12:58 PM, Krzysztof Kozlowski
<k.kozlowski@samsung.com> wrote:

> mfd_add_devices() expects array of struct mfd_cell to be const.
>
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> Cc: Mattias Nilsson <mattias.i.nilsson@stericsson.com>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: linux-arm-kernel@lists.infradead.org

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
