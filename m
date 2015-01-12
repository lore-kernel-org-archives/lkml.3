Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752609AbbALJUa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 04:20:30 -0500
Received: from mail-ig0-f182.google.com ([209.85.213.182]:49311 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752530AbbALJU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 04:20:26 -0500
MIME-Version: 1.0
In-Reply-To: <1418831474-24428-2-git-send-email-ricardo.ribalda@gmail.com>
References: <1418831474-24428-1-git-send-email-ricardo.ribalda@gmail.com>
	<1418831474-24428-2-git-send-email-ricardo.ribalda@gmail.com>
Date: Mon, 12 Jan 2015 10:20:24 +0100
Message-ID: <CACRpkdaPHE4tdh1QOtDjumzgSzyFMO5XVmnKFRY_Y670N7k_0g@mail.gmail.com>
Subject: Re: [PATCH v5 1/7] gpio/xilinx: Remove offset property
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

> Instead of calculating the register offset per call, pre-calculate it on
> probe time.
>
> Acked-by: Alexandre Courbot <acourbot@nvidia.com>
> Acked-by: Michal Simek <michal.simek@xilinx.com>
> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>

Patch applied. Sorry for the fat delays on this patch set.

Yours,
Linus Walleij
