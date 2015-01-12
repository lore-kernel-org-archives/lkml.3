Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752643AbbALJVo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 04:21:44 -0500
Received: from mail-ig0-f170.google.com ([209.85.213.170]:58070 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752388AbbALJVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 04:21:39 -0500
MIME-Version: 1.0
In-Reply-To: <1418831474-24428-3-git-send-email-ricardo.ribalda@gmail.com>
References: <1418831474-24428-1-git-send-email-ricardo.ribalda@gmail.com>
	<1418831474-24428-3-git-send-email-ricardo.ribalda@gmail.com>
Date: Mon, 12 Jan 2015 10:21:38 +0100
Message-ID: <CACRpkdY6Qzb=A=yGPHL8LfsjOEJK5AeqOsDM0wFYmiZ4fwpoaQ@mail.gmail.com>
Subject: Re: [PATCH v5 2/7] gpio/xilinx: Convert the driver to platform device interface
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

> This way we do not need to transverse the device tree manually and we
> support hot plugged devices.
>
> Also Implement remove callback so the driver can be unloaded
>
> Acked-by: Michal Simek <michal.simek@xilinx.com>
> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>

Patch applied.

Yours,
Linus Walleij
