Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756087Ab3KZKb6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 05:31:58 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:51748 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753849Ab3KZKb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 05:31:56 -0500
Message-ID: <52947869.4040101@ti.com>
Date: Tue, 26 Nov 2013 16:01:05 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Matt Porter <matt.porter@linaro.org>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>, Kumar Gala <galak@codeaurora.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Christian Daudt <bcm@fixthebug.org>,
        Paul Zimmerman <paulz@synopsys.com>
CC: Tomasz Figa <t.figa@samsung.com>, Kamil Debski <k.debski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Linux USB List <linux-usb@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Devicetree List <devicetree@vger.kernel.org>,
        Linaro Patches <patches@linaro.org>
Subject: Re: [PATCH v3 7/9] phy: add Broadcom Kona USB2 PHY DT binding
References: <1385403367-18144-1-git-send-email-matt.porter@linaro.org> <1385403367-18144-8-git-send-email-matt.porter@linaro.org>
In-Reply-To: <1385403367-18144-8-git-send-email-matt.porter@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Monday 25 November 2013 11:46 PM, Matt Porter wrote:
> Add a binding that describes the Broadcom Kona USB2 PHY found
> on the BCM281xx family of SoCs.
> 
> Signed-off-by: Matt Porter <matt.porter@linaro.org>
> ---
>  .../devicetree/bindings/phy/bcm-kona-usb2-phy.txt         | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/phy/bcm-kona-usb2-phy.txt
> 
> diff --git a/Documentation/devicetree/bindings/phy/bcm-kona-usb2-phy.txt b/Documentation/devicetree/bindings/phy/bcm-kona-usb2-phy.txt
> new file mode 100644
> index 0000000..3dc8b3d
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/phy/bcm-kona-usb2-phy.txt

you should name this bcm-phy. Then you can add binding info of all (future) PHY
IP from broadcom here.

other than that this looks fine..
Acked-by: Kishon Vijay Abraham I <kishon@ti.com>

Thanks
Kishon
