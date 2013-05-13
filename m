Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451Ab3EMSJF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 14:09:05 -0400
Received: from us02smtp1.synopsys.com ([198.182.60.75]:53500 "EHLO
	vaxjo.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752114Ab3EMSJD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 14:09:03 -0400
From: Paul Zimmerman <Paul.Zimmerman@synopsys.com>
To: Federico Vaga <federico.vaga@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Giancarlo Asnaghi" <giancarlo.asnaghi@st.com>
Subject: RE: [PATCH] dwc2/pci.c: add STMICRO vendor and device ID for
 STA2X11 board
Thread-Topic: [PATCH] dwc2/pci.c: add STMICRO vendor and device ID for
 STA2X11 board
Thread-Index: AQHOUAMAJaWm+M5B00GNsXwz+mpcxpkDaRLQ
Date: Mon, 13 May 2013 18:09:01 +0000
Message-ID: <A2CA0424C0A6F04399FB9E1CD98E030458DC5CD9@US01WEMBX2.internal.synopsys.com>
References: <1368467652-19940-1-git-send-email-federico.vaga@gmail.com>
In-Reply-To: <1368467652-19940-1-git-send-email-federico.vaga@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.9.64.241]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Federico Vaga [mailto:federico.vaga@gmail.com]
> Sent: Monday, May 13, 2013 10:54 AM
> 
> add STMICRO vendor and device ID for STA2X11 board
> 
> Signed-off-by: Federico Vaga <federico.vaga@gmail.com>
> Acked-by: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>
> ---
>  drivers/staging/dwc2/pci.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/staging/dwc2/pci.c b/drivers/staging/dwc2/pci.c
> index 69c65eb..7029b9f 100644
> --- a/drivers/staging/dwc2/pci.c
> +++ b/drivers/staging/dwc2/pci.c
> @@ -162,6 +162,10 @@ static DEFINE_PCI_DEVICE_TABLE(dwc2_pci_ids) = {
>  	{
>  		PCI_DEVICE(PCI_VENDOR_ID_SYNOPSYS, PCI_PRODUCT_ID_HAPS_HSOTG),
>  	},
> +	{
> +		PCI_DEVICE(PCI_VENDOR_ID_STMICRO,
> +			   PCI_DEVICE_ID_STMICRO_USB_OTG),
> +	},
>  	{ /* end: all zeroes */ }
>  };
>  MODULE_DEVICE_TABLE(pci, dwc2_pci_ids);

Acked-by: Paul Zimmerman <paulz@synopsys.com>

