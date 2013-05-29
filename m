Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756497Ab3E2PdJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 11:33:09 -0400
Received: from mail-vc0-f170.google.com ([209.85.220.170]:33524 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754111Ab3E2PdG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 11:33:06 -0400
MIME-Version: 1.0
In-Reply-To: <1369827811-534-3-git-send-email-rogerq@ti.com>
References: <1369827811-534-1-git-send-email-rogerq@ti.com>
	<1369827811-534-3-git-send-email-rogerq@ti.com>
Date: Wed, 29 May 2013 11:33:05 -0400
Message-ID: <CANsc=4VicTFGLO_zbDDsQam3dKsNNUgvQa=zR_u7beKseWh3UA@mail.gmail.com>
Subject: Re: [PATCH 2/5] USB: ehci-omap: select NOP_USB_XCEIV PHY driver
From: =?UTF-8?Q?Adrien_Verg=C3=A9?= <adrienverge@gmail.com>
To: Roger Quadros <rogerq@ti.com>
Cc: gregkh@linuxfoundation.org, balbi@ti.com, stern@rowland.harvard.edu,
        kishon@ti.com, arnd@arndb.de, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/5/29 Roger Quadros <rogerq@ti.com>:
> ehci-omap needs NOP_USB_XCEIV PHY driver to function
> properly, so select it. As the USB PHY drivers no longer
> depend on USB_PHY, it is safe to select the PHY drivers.
>
> Signed-off-by: Roger Quadros <rogerq@ti.com>

Acked-by: Adrien Vergé <adrienverge@gmail.com>
Tested-by: Adrien Vergé <adrienverge@gmail.com>

Works well on Pandaboard (OMAP4430).
Thank you!
