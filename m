Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672AbbAFJ2i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 04:28:38 -0500
Received: from smtp1.hiworks.co.kr ([121.254.168.204]:49464 "EHLO
	smtp1.hiworks.co.kr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754620AbbAFJ2g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 04:28:36 -0500
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Tue, 06 Jan 2015 04:28:35 EST
From: "kyhw" <kyhw@afoi.co.kr>
To: "'Jiri Kosina'" <jkosina@suse.cz>
Cc: <rydberg@euromail.se>, <linux-input@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <006101cf4812$c3ac1680$4b044380$@afoi.co.kr> <alpine.LNX.2.00.1403251156260.17500@pobox.suse.cz> <003a01cf488c$ab9c4400$02d4cc00$@afoi.co.kr> <alpine.LNX.2.00.1405201643120.1615@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1405201643120.1615@pobox.suse.cz>
Subject: RE: [PATCH] Add VID/PID for HID-type Multi-Touch Module of AFO CO.,   LTD.
Date: Tue, 6 Jan 2015 18:21:57 +0900
Message-ID: <001701d02992$37f595f0$a7e0c1d0$@co.kr>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AQHgmKd00nK6Cd07QSZGmulK6nUVggGjAdY6AfVuB5sCGKpo2ZxkYYBw
Content-Language: ko
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks.

you are right. That's not necessary.
We already processed.

The final purpose of my approach is that the correct working of the AFO
multi-Touch module in All distribution of Linux.
Therefore, the inclusion of the VID,PID(AFO Touch Module) to the
hid-multitouch module is basically needed also for old version of the Linux
distribution.

Ki.

-----Original Message-----
From: Jiri Kosina [mailto:jkosina@suse.cz] 
Sent: Tuesday, May 20, 2014 11:44 PM
To: YongHwan Ki
Cc: rydberg@euromail.se; linux-input@vger.kernel.org;
linux-kernel@vger.kernel.org
Subject: RE: [PATCH] Add VID/PID for HID-type Multi-Touch Module of AFO CO.,
LTD.

On Wed, 26 Mar 2014, YongHwan Ki wrote:

> Sorry, I woud like to add the AFO defines in the Linux Kernel.
> No afo defines exists in the current kernel tree.
> I correctly changed the log for adding the afo defines.
> 
> Kernel Version : linux-3.14.rc7
> Signed-off-by: Yonghwan Ki <kyhw@afoi.co.kr>
> 
> diff -uprN -X Documentation/dontdiff ./drivers/hid/hid-core.c
../linux-3.14-rc7m/drivers/hid/hid-core.c
> --- ./drivers/hid/hid-core.c	2014-03-17 10:51:24.000000000 +0900
> +++ ../linux-3.14-rc7m/drivers/hid/hid-core.c	2014-03-21
17:41:51.846939444 +0900
> @@ -1881,6 +1881,8 @@ static const struct hid_device_id hid_ha
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_ZEROPLUS, 0x0005) },
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_ZEROPLUS, 0x0030) },
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_ZYDACRON, 
> USB_DEVICE_ID_ZYDACRON_REMOTE_CONTROL) },
> +	{ HID_USB_DEVICE(USB_VENDOR_ID_AFO, USB_DEVICE_ID_AFO_TCM) },
> +	{ HID_USB_DEVICE(USB_VENDOR_ID_AFO, USB_DEVICE_ID_AFO_THM) },

Is this really necessary? Why doesn't HID_DG_CONTACTID matching work for the
to automatically trigger HID_GROUP_MULTITOUCH-based binding?

--
Jiri Kosina
SUSE Labs


