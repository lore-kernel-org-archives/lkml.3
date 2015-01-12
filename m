Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753019AbbALJbU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 04:31:20 -0500
Received: from mail-ig0-f182.google.com ([209.85.213.182]:47874 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752027AbbALJbP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 04:31:15 -0500
MIME-Version: 1.0
In-Reply-To: <1418831474-24428-8-git-send-email-ricardo.ribalda@gmail.com>
References: <1418831474-24428-1-git-send-email-ricardo.ribalda@gmail.com>
	<1418831474-24428-8-git-send-email-ricardo.ribalda@gmail.com>
Date: Mon, 12 Jan 2015 10:31:14 +0100
Message-ID: <CACRpkdYNg8N4f35PccM3y+DbokUsPYYL9sDxKkZOQ2W_TqD64A@mail.gmail.com>
Subject: Re: [PATCH v5 7/7] gpio/xilinx: Use of_mm_gpiochip_remove
From: Linus Walleij <linus.walleij@linaro.org>
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: Alexandre Courbot <gnurou@gmail.com>,
        Michal Simek <michal.simek@xilinx.com>,
        =?UTF-8?Q?S=C3=B6ren_Brinkmann?= <soren.brinkmann@xilinx.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 17, 2014 at 4:51 PM, Ricardo Ribalda Delgado
<ricardo.ribalda@gmail.com> wrote:

> Use the newly created of_mm_gpiochip_remove function for cleaning up
> of_mm_gpiochip_add
>
> Suggested-by: Alexandre Courbot <gnurou@gmail.com>
> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>

Patch applied.

Yours,
Linus Walleij
