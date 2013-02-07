Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758427Ab3BGPoB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 10:44:01 -0500
Received: from mail-ia0-f173.google.com ([209.85.210.173]:51241 "EHLO
	mail-ia0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057Ab3BGPn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 10:43:57 -0500
MIME-Version: 1.0
In-Reply-To: <1360148051-7560-29-git-send-email-lee.jones@linaro.org>
References: <1360148051-7560-1-git-send-email-lee.jones@linaro.org>
	<1360148051-7560-29-git-send-email-lee.jones@linaro.org>
Date: Thu, 7 Feb 2013 16:43:54 +0100
Message-ID: <CACRpkdZyjmW5q8LWeqU658N4ftfkGyQeDJZgEe+jGCMy7n4Yqg@mail.gmail.com>
Subject: Re: [PATCH 28/49] ARM: ux500: regulator: Use device IDs instead of
 device names
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, broonie@opensource.wolfsonmicro.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 6, 2013 at 11:53 AM, Lee Jones <lee.jones@linaro.org> wrote:

> Remove device name from sensor platform data and change regulator
> names according to device name.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Ugh...

>         /* L3G4200D Gyroscope device */
> -       REGULATOR_SUPPLY("vdd", "l3g4200d"),
> -       /* Proximity and Hal sensor device */
> -       REGULATOR_SUPPLY("vdd", "sensor1p.0"),
> +       REGULATOR_SUPPLY("vdd", "2-0068"),

Didn't you just add that supply with the funny name in that other
patch I complained about.... Please merge them into one patch.

Yours,
Linus Walleij
