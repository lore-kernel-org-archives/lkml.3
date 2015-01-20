Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522AbbATKJG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 05:09:06 -0500
Received: from mail-ie0-f170.google.com ([209.85.223.170]:56083 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753062AbbATKJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 05:09:01 -0500
MIME-Version: 1.0
In-Reply-To: <1421581173-28416-4-git-send-email-ricardo.ribalda@gmail.com>
References: <1421581173-28416-1-git-send-email-ricardo.ribalda@gmail.com>
	<1421581173-28416-4-git-send-email-ricardo.ribalda@gmail.com>
Date: Tue, 20 Jan 2015 11:09:01 +0100
Message-ID: <CACRpkda7v2tfDW9JikRizf0tDpmf=1SY7j9pwErxE9ArWkJhmg@mail.gmail.com>
Subject: Re: [PATCH 3/8] gpio/mm-lantiq: Do not replicate code
From: Linus Walleij <linus.walleij@linaro.org>
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        John Crispin <blogic@openwrt.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 18, 2015 at 12:39 PM, Ricardo Ribalda Delgado
<ricardo.ribalda@gmail.com> wrote:

> Do not replicate code from of_mm_gpiochip_add.
>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Alexandre Courbot <gnurou@gmail.com>
> Cc: John Crispin <blogic@openwrt.org>
> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>

Patch applied.

Yours,
Linus Walleij
