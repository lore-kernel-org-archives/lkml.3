Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755847AbaLJKtw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 05:49:52 -0500
Received: from mail-ie0-f176.google.com ([209.85.223.176]:57754 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755761AbaLJKtl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 05:49:41 -0500
MIME-Version: 1.0
In-Reply-To: <1418051276-5476-3-git-send-email-ricardo.ribalda@gmail.com>
References: <1418051276-5476-1-git-send-email-ricardo.ribalda@gmail.com> <1418051276-5476-3-git-send-email-ricardo.ribalda@gmail.com>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Wed, 10 Dec 2014 19:49:20 +0900
Message-ID: <CAAVeFuKj1ekbGyn_bLVN9ndF=B=H=2HQXDzjEvhes=GCcVyv_A@mail.gmail.com>
Subject: Re: [PATCH 2/4] gpio/xilinx: Convert the driver to platform device interface
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Michal Simek <michal.simek@xilinx.com>,
        =?UTF-8?Q?S=C3=B6ren_Brinkmann?= <soren.brinkmann@xilinx.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 9, 2014 at 12:07 AM, Ricardo Ribalda Delgado
<ricardo.ribalda@gmail.com> wrote:
> This way we do not need to transverse the device tree manually and we
> support hot plugged devices.

Looks ok at first sight, but I think patch 3 should be merged into
this one. They are really closely related.
