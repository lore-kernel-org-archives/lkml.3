Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751493AbaDUExh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 00:53:37 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:50373 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744AbaDUExb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 00:53:31 -0400
MIME-Version: 1.0
In-Reply-To: <5354175B.3070109@pengutronix.de>
References: <7aed4ee6-69e7-4f9f-9f45-675bc695089c@CO9EHSMHS031.ehs.local>
	<5354175B.3070109@pengutronix.de>
Date: Mon, 21 Apr 2014 10:23:30 +0530
X-Google-Sender-Auth: fVX-WVRMXUMm_5EccdxiBXzu4b4
Message-ID: <CAGnW=Bav_Q_ZpkFq0gG7m9+OBnPWyPhOoBTNnP=VdErzcwe2dQ@mail.gmail.com>
Subject: Re: [RFC PATCH 0/2] usb: Reuse fsl driver code for synopsys usb controller
From: punnaiah choudary kalluri <punnaia@xilinx.com>
To: Marc Kleine-Budde <mkl@pengutronix.de>
Cc: Punnaiah Choudary Kalluri <punnaiah.choudary.kalluri@xilinx.com>,
        leoli@freescale.com, balbi@ti.com,
        "michal.simek@xilinx.com" <michal.simek@xilinx.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linuxppc-dev@lists.ozlabs.org, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org, Punnaiah Choudary <kpc528@gmail.com>,
        Peter Chen <peter.chen@freescale.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 21, 2014 at 12:22 AM, Marc Kleine-Budde <mkl@pengutronix.de> wrote:
> On 04/20/2014 06:27 PM, Punnaiah Choudary Kalluri wrote:
>> Zynq soc contains a dual role usb controller and this IP is from synopsys. We
>> observed that there is driver available for this controller from freescale and
>> decided to reuse this driver for zynq use.
>
> Have a look drivers/usb/chipidea. It's maintained by Peter Chen (Cc'ed)
> and is in better shape than the freescale driver.

Thanks. I will check this implementation and also check with Peter Chen if
i have any concerns about this implementation.

Punnaiah.
>
> Marc
>
> --
> Pengutronix e.K.                  | Marc Kleine-Budde           |
> Industrial Linux Solutions        | Phone: +49-231-2826-924     |
> Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
> Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |
>
