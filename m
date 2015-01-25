Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754263AbbAYQV3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 11:21:29 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54765 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754124AbbAYQPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 11:15:39 -0500
Date: Sun, 25 Jan 2015 20:01:30 +0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Asaf Vertz <asaf.vertz@tandemg.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: wlan-ng: hfa384x_usb: fix sparse endianness
 warnings
Message-ID: <20150125120130.GB14049@kroah.com>
References: <20150118071139.GA2248@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150118071139.GA2248@ubuntu>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 18, 2015 at 09:11:39AM +0200, Asaf Vertz wrote:
> Fixed the following warnings (reported by sparse):
> drivers/staging/wlan-ng/hfa384x_usb.c:3828:36: warning: cast to restricted __le16
> drivers/staging/wlan-ng/hfa384x_usb.c:3229:16: warning: cast to restricted __le16
> drivers/staging/wlan-ng/hfa384x_usb.c:3430:18: warning: cast to restricted __le16
> drivers/staging/wlan-ng/hfa384x_usb.c:3349:51: warning: restricted __le16 degrades to integer
> drivers/staging/wlan-ng/hfa384x_usb.c:3357:37: warning: cast to restricted __le16
> drivers/staging/wlan-ng/hfa384x_usb.c:3358:37: warning: cast to restricted __le16
> drivers/staging/wlan-ng/hfa384x_usb.c:3393:36: warning: cast to restricted __le16
> drivers/staging/wlan-ng/hfa384x_usb.c:3102:28: warning: cast to restricted __le16
> drivers/staging/wlan-ng/hfa384x_usb.c:3004:28: warning: cast to restricted __le16
> drivers/staging/wlan-ng/hfa384x_usb.c:1308:37: warning: cast to restricted __le16
> drivers/staging/wlan-ng/hfa384x_usb.c:2713:25: warning: incorrect type in assignment (different base types)
> drivers/staging/wlan-ng/hfa384x_usb.c:2713:25:    expected unsigned short [unsigned] [usertype] type
> drivers/staging/wlan-ng/hfa384x_usb.c:2713:25:    got restricted __le16 [usertype] <noident>
> 
> Signed-off-by: Asaf Vertz <asaf.vertz@tandemg.com>
> ---
>  drivers/staging/wlan-ng/hfa384x.h     |    4 ++--
>  drivers/staging/wlan-ng/hfa384x_usb.c |    2 +-
>  2 files changed, 3 insertions(+), 3 deletions(-)

Applied, thanks.

greg k-h
