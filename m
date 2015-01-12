Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752615AbbALJdz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 04:33:55 -0500
Received: from mail-ig0-f181.google.com ([209.85.213.181]:45132 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916AbbALJdx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 04:33:53 -0500
MIME-Version: 1.0
In-Reply-To: <CAPybu_1n0mGjm+Si_e4soVcQgGbP=fPFXDU71f3bvABDLraNVQ@mail.gmail.com>
References: <1418831474-24428-1-git-send-email-ricardo.ribalda@gmail.com>
	<1418831474-24428-7-git-send-email-ricardo.ribalda@gmail.com>
	<CACRpkdYq_tyamCzM575D8vdMg_rvDy93fSm+7Oss3tQzFu+TTA@mail.gmail.com>
	<CAPybu_1n0mGjm+Si_e4soVcQgGbP=fPFXDU71f3bvABDLraNVQ@mail.gmail.com>
Date: Mon, 12 Jan 2015 10:33:49 +0100
Message-ID: <CACRpkdaGtCrhYpGwCkS02pryT-RjVNX7cHTnQaw7EuEHLP7SUA@mail.gmail.com>
Subject: Re: [PATCH v5 6/7] gpio/gpiolib-of: Create of_mm_gpiochip_remove
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

On Mon, Jan 12, 2015 at 10:31 AM, Ricardo Ribalda Delgado
<ricardo.ribalda@gmail.com> wrote:

> I think that only gpio-mpc5200.c would benefit from the new API, I can
> send a patchset to support removal and use the new API if you want.

That would be awesome.

Yours,
Linus Walleij
