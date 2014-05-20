Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753051AbaETOoG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 10:44:06 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55460 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751161AbaETOoD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 10:44:03 -0400
Date: Tue, 20 May 2014 16:44:01 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: YongHwan Ki <kyhw@afoi.co.kr>
cc: rydberg@euromail.se, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: RE: [PATCH] Add VID/PID for HID-type Multi-Touch Module of AFO CO.,
  LTD.
In-Reply-To: <003a01cf488c$ab9c4400$02d4cc00$@afoi.co.kr>
Message-ID: <alpine.LNX.2.00.1405201643120.1615@pobox.suse.cz>
References: <006101cf4812$c3ac1680$4b044380$@afoi.co.kr> <alpine.LNX.2.00.1403251156260.17500@pobox.suse.cz> <003a01cf488c$ab9c4400$02d4cc00$@afoi.co.kr>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Mar 2014, YongHwan Ki wrote:

> Sorry, I woud like to add the AFO defines in the Linux Kernel.
> No afo defines exists in the current kernel tree.
> I correctly changed the log for adding the afo defines.
> 
> Kernel Version : linux-3.14.rc7
> Signed-off-by: Yonghwan Ki <kyhw@afoi.co.kr>
> 
> diff -uprN -X Documentation/dontdiff ./drivers/hid/hid-core.c ../linux-3.14-rc7m/drivers/hid/hid-core.c
> --- ./drivers/hid/hid-core.c	2014-03-17 10:51:24.000000000 +0900
> +++ ../linux-3.14-rc7m/drivers/hid/hid-core.c	2014-03-21 17:41:51.846939444 +0900
> @@ -1881,6 +1881,8 @@ static const struct hid_device_id hid_ha
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_ZEROPLUS, 0x0005) },
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_ZEROPLUS, 0x0030) },
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_ZYDACRON, USB_DEVICE_ID_ZYDACRON_REMOTE_CONTROL) },
> +	{ HID_USB_DEVICE(USB_VENDOR_ID_AFO, USB_DEVICE_ID_AFO_TCM) },
> +	{ HID_USB_DEVICE(USB_VENDOR_ID_AFO, USB_DEVICE_ID_AFO_THM) },

Is this really necessary? Why doesn't HID_DG_CONTACTID matching work for 
the to automatically trigger HID_GROUP_MULTITOUCH-based binding?

-- 
Jiri Kosina
SUSE Labs
