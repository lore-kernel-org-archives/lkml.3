Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932153AbaICVB0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 17:01:26 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:34352 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753677AbaICVBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 17:01:24 -0400
Message-ID: <5407819B.2060605@gmail.com>
Date: Wed, 03 Sep 2014 23:01:15 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
To: Antoine Tenart <antoine.tenart@free-electrons.com>,
        Peter.Chen@freescale.com, balbi@ti.com, p.zabel@pengutronix.de
CC: alexandre.belloni@free-electrons.com, thomas.petazzoni@free-electrons.com,
        zmxu@marvell.com, jszhang@marvell.com,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 01/12] reset: add the Berlin reset controller driver
References: <1409730511-16101-1-git-send-email-antoine.tenart@free-electrons.com> <1409730511-16101-2-git-send-email-antoine.tenart@free-electrons.com>
In-Reply-To: <1409730511-16101-2-git-send-email-antoine.tenart@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/03/2014 09:48 AM, Antoine Tenart wrote:
> Add a reset controller for Marvell Berlin SoCs which is used by the
> USB PHYs drivers (for now).
> 
> Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> Acked-by: Philipp Zabel <p.zabel@pengutronix.de>
> ---
>  drivers/reset/Makefile       |   1 +
>  drivers/reset/reset-berlin.c | 131 +++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 132 insertions(+)
>  create mode 100644 drivers/reset/reset-berlin.c

I guess the reset stuff is quite independent from usb-phy and can
be picked up now.

Applied
01/12 and 03/12 to berlin/soc and
02/12 and 04/12 to berlin/dt.

Thanks!

For the usb-phy dts patches, I'll wait for the corresponding genphy
patches.

Sebastian

