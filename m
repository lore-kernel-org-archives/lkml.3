Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753163AbbALJc7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 04:32:59 -0500
Received: from mail-ie0-f172.google.com ([209.85.223.172]:39410 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752653AbbALJc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 04:32:58 -0500
MIME-Version: 1.0
In-Reply-To: <CAPybu_0zkL5MokpWtckz7tC1XWXcEUXoUvriiUZ2Q7yt6p5-MQ@mail.gmail.com>
References: <1418831474-24428-1-git-send-email-ricardo.ribalda@gmail.com>
	<CAPybu_0zkL5MokpWtckz7tC1XWXcEUXoUvriiUZ2Q7yt6p5-MQ@mail.gmail.com>
Date: Mon, 12 Jan 2015 10:32:57 +0100
Message-ID: <CACRpkdavuy+ww6FTnbH==zSRu9gaM2V0LjK0rbKUAoufv0p-3g@mail.gmail.com>
Subject: Re: [PATCH v5 0/7]gpio/xilinx: Add support for PCI mapped devices and rmmod
From: Linus Walleij <linus.walleij@linaro.org>
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: Alexandre Courbot <gnurou@gmail.com>,
        Michal Simek <michal.simek@xilinx.com>,
        =?UTF-8?Q?S=C3=B6ren_Brinkmann?= <soren.brinkmann@xilinx.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 1, 2015 at 4:27 PM, Ricardo Ribalda Delgado
<ricardo.ribalda@gmail.com> wrote:

> I am back from holidays. If there is any change that you want on this
> series please share.

Noone says anything so I applied them all.
Looks good to me anyway.

Check the question of whether we should audit other drivers to
use of_mm_gpiochip_remove().

Yours,
Linus Walleij
