Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754104AbaIHPYH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 11:24:07 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:57978 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752973AbaIHPYG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 11:24:06 -0400
Message-ID: <540DC9F6.8090306@ti.com>
Date: Mon, 8 Sep 2014 20:53:34 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Peter Griffin <peter.griffin@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <srinivas.kandagatla@gmail.com>, <maxime.coquelin@st.com>,
        <patrice.chotard@st.com>
CC: <lee.jones@linaro.org>, <devicetree@vger.kernel.org>
Subject: Re: [PATCH 0/3]  Add picoPHY usb phy driver found on stih407 family
 SoC's
References: <1409740079-16554-1-git-send-email-peter.griffin@linaro.org>
In-Reply-To: <1409740079-16554-1-git-send-email-peter.griffin@linaro.org>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wednesday 03 September 2014 03:57 PM, Peter Griffin wrote:
> This series adds support for the picoPHY usb phy which is used by the usb2
> and usb3 host controllers when controlling usb2/1.1 devices. It is found on
> stih407 family SoC's from the consumer electronics devision of STMicroelectronics.

So miphy28lp is the PHY controller for USB3 device controller and picoPHY is
the PHY controller for USB3 host controller?

Thanks
Kishon

> 
> Peter Griffin (3):
>   phy: phy-stih407-usb: Add usb picoPHY driver found on stih407 SoC
>     family
>   phy: phy-stih407-usb: Add dt documentation for USB picophy found on
>     stih407 SoC family
>   MAINTAINERS: Add phy-stih407-usb.c file to ARCH/STI architecture
> 
>  .../devicetree/bindings/phy/phy-stih407-usb.txt    |  37 +++++
>  MAINTAINERS                                        |   1 +
>  drivers/phy/Kconfig                                |   8 +
>  drivers/phy/Makefile                               |   2 +
>  drivers/phy/phy-stih407-usb.c                      | 185 +++++++++++++++++++++
>  5 files changed, 233 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/phy/phy-stih407-usb.txt
>  create mode 100644 drivers/phy/phy-stih407-usb.c
> 
