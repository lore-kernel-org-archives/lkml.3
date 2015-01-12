Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752870AbbALJ1m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 04:27:42 -0500
Received: from mail-ie0-f172.google.com ([209.85.223.172]:53890 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752854AbbALJ1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 04:27:40 -0500
MIME-Version: 1.0
In-Reply-To: <1418831474-24428-6-git-send-email-ricardo.ribalda@gmail.com>
References: <1418831474-24428-1-git-send-email-ricardo.ribalda@gmail.com>
	<1418831474-24428-6-git-send-email-ricardo.ribalda@gmail.com>
Date: Mon, 12 Jan 2015 10:27:39 +0100
Message-ID: <CACRpkdZZFrjD1LTZK9_wS=TnOKnY57LiMZUV5uD1_Ks04Kgzzg@mail.gmail.com>
Subject: Re: [PATCH v5 5/7] gpio/xilinx: Create a single gpio chip on dual cores
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

> Currently, we had two gpio chips on cores configured as dual.
>
> This lead to mapping the same memory region twice and duplicating the
> init and remove code.
>
> This patch creates a single gpiochip for single and dual cores.
>
> Suggested-by: Alexandre Courbot <gnurou@gmail.com>
> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>

Patch applied.

Yours,
Linus Walleij
