Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751275AbaGJEwu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 00:52:50 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:57751 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780AbaGJEwt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 00:52:49 -0400
MIME-Version: 1.0
In-Reply-To: <1404966228-29133-1-git-send-email-jy0922.shim@samsung.com>
References: <1404966228-29133-1-git-send-email-jy0922.shim@samsung.com>
Date: Thu, 10 Jul 2014 10:22:46 +0530
Message-ID: <CAK5sBcFKOc-_aGuC8QQu_NHc67AfZGz0MUeURqVr8P6K3Zzzmg@mail.gmail.com>
Subject: Re: [PATCH 1/3] usb: usb3503: fix build warning
From: Sachin Kamat <spk.linux@gmail.com>
To: Joonyoung Shim <jy0922.shim@samsung.com>
Cc: Linux USB Mailing List <linux-usb@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Mark Brown <broonie@linaro.org>, tobetter@gmail.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joonyoung,

On Thu, Jul 10, 2014 at 9:53 AM, Joonyoung Shim <jy0922.shim@samsung.com> wrote:
> This fixes below build warning.
>
> drivers/usb/misc/usb3503.c: In function ‘usb3503_probe’:
> drivers/usb/misc/usb3503.c:195:11: warning: ‘err’ may be used uninitialized in this function [-Wmaybe-uninitialized]
>     dev_err(dev, "unable to request refclk (%d)\n", err);
>            ^

This has been fixed and availabe in Greg's usb-next tree.
https://git.kernel.org/cgit/linux/kernel/git/gregkh/usb.git/commit/?h=usb-next&id=ec5734c41bee2ee7c938a8f34853d31cada7e67a

-- 
Regards,
Sachin.
