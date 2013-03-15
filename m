Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755252Ab3COSn6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 14:43:58 -0400
Received: from mail-vb0-f48.google.com ([209.85.212.48]:43183 "EHLO
	mail-vb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753240Ab3COSn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 14:43:57 -0400
Date: Fri, 15 Mar 2013 15:43:49 -0300
From: Gustavo Padovan <gustavo@padovan.org>
To: Lubomir Rintel <lkundrak@v3.sk>
Cc: linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marcel Holtmann <marcel@holtmann.org>
Subject: Re: [PATCH RESEND] bluetooth: btmrvl_sdio: look for sd8688 firmware
 in proper location
Message-ID: <20130315184349.GB20196@joana>
Mail-Followup-To: Gustavo Padovan <gustavo@padovan.org>,
	Lubomir Rintel <lkundrak@v3.sk>, linux-bluetooth@vger.kernel.org,
	linux-kernel@vger.kernel.org, Marcel Holtmann <marcel@holtmann.org>
References: <1363172670-14596-1-git-send-email-lkundrak@v3.sk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363172670-14596-1-git-send-email-lkundrak@v3.sk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lubomir,

* Lubomir Rintel <lkundrak@v3.sk> [2013-03-13 12:04:30 +0100]:

> The firmware images are shared with libertas_sdio WiFi chip and used to be in
> libertas/ subtree in linux-firmware. As btmrvl_sdio used to look into the
> linux-firmware root, it ended up being unsuccessful. Since the firmware files
> are not specific to the libertas hardware, they're being moved into mrvl/ now.
> 
> Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
> Acked-by: Marcel Holtmann <marcel@holtmann.org>
> ---
> 
> Now that the relevant changes are in linux-firmware it makes sense to merge 
> this to make the driver look for correct firmware files.
> 
>  drivers/bluetooth/btmrvl_sdio.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)

Patch has been applied to bluetooth-next. Thanks.

	Gustavo
