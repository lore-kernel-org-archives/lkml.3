Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753239Ab3LBR7j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 12:59:39 -0500
Received: from mail-la0-f48.google.com ([209.85.215.48]:46075 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753214Ab3LBR7d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 12:59:33 -0500
Message-ID: <529CD892.5010601@cogentembedded.com>
Date: Mon, 02 Dec 2013 21:59:30 +0300
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Chris Ruehl <chris.ruehl@gtsys.com.hk>, balbi@ti.com,
        gregkh@linuxfoundation.org
CC: linux-usb@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] usb: phy-ulpi: Add EXTVBUSIND,CHRGVBUS flag support
References: <1385967919-13258-1-git-send-email-chris.ruehl@gtsys.com.hk> <1385967919-13258-3-git-send-email-chris.ruehl@gtsys.com.hk>
In-Reply-To: <1385967919-13258-3-git-send-email-chris.ruehl@gtsys.com.hk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/02/2013 10:05 AM, Chris Ruehl wrote:

> usb: phy-ulpi: Add EXTVBUSIND,CHRGVBUS flag support

> ULPI like ISP1504 support external vbus power indication
> used in combination with vbus switches mic2075.

> Signed-off-by: Chris Ruehl <chris.ruehl@gtsys.com.hk>
> ---
>   drivers/usb/phy/phy-ulpi.c |   11 ++++++++++-
>   1 file changed, 10 insertions(+), 1 deletion(-)

> diff --git a/drivers/usb/phy/phy-ulpi.c b/drivers/usb/phy/phy-ulpi.c
> index 217339d..e2f15c4 100644
> --- a/drivers/usb/phy/phy-ulpi.c
> +++ b/drivers/usb/phy/phy-ulpi.c
> @@ -180,6 +180,8 @@ static int ulpi_init(struct usb_phy *phy)
>   	int i, vid, pid, ret;
>   	u32 ulpi_id = 0;
>
> +	pr_info("ULPI Viewport 0x%p\n",phy->io_priv);
> +

    You forgot space after comma.

WBR, Sergei

