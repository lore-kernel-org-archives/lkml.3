Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754217AbaGOPIB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 11:08:01 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41945 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478AbaGOPH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 11:07:59 -0400
Date: Tue, 15 Jul 2014 08:07:38 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Peter Senna Tschudin <peter.senna@gmail.com>
Cc: forest@alittletooquiet.net, tvboxspy@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH V4 5/6] staging: vt6556: Cleanup indentation on statements
Message-ID: <20140715150738.GB19185@kroah.com>
References: <1405365333-17170-1-git-send-email-peter.senna@gmail.com>
 <1405365333-17170-5-git-send-email-peter.senna@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405365333-17170-5-git-send-email-peter.senna@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 14, 2014 at 09:15:32PM +0200, Peter Senna Tschudin wrote:
> Use tabs instead of spaces in a set of statements and fix lines
> over 80 chars. Reported by checkpatch.
> 
> Tested by compilation only.
> 
> Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
> ---
> Cahnges from V3:
>  - Splitted the patches by change type
> 
>  drivers/staging/vt6656/main_usb.c | 44 ++++++++++++++++++++-------------------
>  1 file changed, 23 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
> index 553a8e9..cc0281a 100644
> --- a/drivers/staging/vt6656/main_usb.c
> +++ b/drivers/staging/vt6656/main_usb.c
> @@ -382,38 +382,40 @@ static int device_init_registers(struct vnt_private *pDevice)
>  	/* load vt3266 calibration parameters in EEPROM */
>  	if (pDevice->byRFType == RF_VT3226D0) {
>  		if ((pDevice->abyEEPROM[EEP_OFS_MAJOR_VER] == 0x1) &&
> -			(pDevice->abyEEPROM[EEP_OFS_MINOR_VER] >= 0x4)) {
> +		   (pDevice->abyEEPROM[EEP_OFS_MINOR_VER] >= 0x4)) {

Shouldn't this be indented by 1 more space?

thanks,

greg k-h
