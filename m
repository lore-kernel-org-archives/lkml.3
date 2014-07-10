Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751045AbaGJFGA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 01:06:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51084 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750702AbaGJFF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 01:05:58 -0400
Date: Wed, 9 Jul 2014 22:05:39 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Sachin Kamat <spk.linux@gmail.com>
Cc: Joonyoung Shim <jy0922.shim@samsung.com>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Mark Brown <broonie@linaro.org>, tobetter@gmail.com
Subject: Re: [PATCH 1/3] usb: usb3503: fix build warning
Message-ID: <20140710050539.GD14064@kroah.com>
References: <1404966228-29133-1-git-send-email-jy0922.shim@samsung.com>
 <CAK5sBcFKOc-_aGuC8QQu_NHc67AfZGz0MUeURqVr8P6K3Zzzmg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAK5sBcFKOc-_aGuC8QQu_NHc67AfZGz0MUeURqVr8P6K3Zzzmg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2014 at 10:22:46AM +0530, Sachin Kamat wrote:
> Hi Joonyoung,
> 
> On Thu, Jul 10, 2014 at 9:53 AM, Joonyoung Shim <jy0922.shim@samsung.com> wrote:
> > This fixes below build warning.
> >
> > drivers/usb/misc/usb3503.c: In function ‘usb3503_probe’:
> > drivers/usb/misc/usb3503.c:195:11: warning: ‘err’ may be used uninitialized in this function [-Wmaybe-uninitialized]
> >     dev_err(dev, "unable to request refclk (%d)\n", err);
> >            ^
> 
> This has been fixed and availabe in Greg's usb-next tree.
> https://git.kernel.org/cgit/linux/kernel/git/gregkh/usb.git/commit/?h=usb-next&id=ec5734c41bee2ee7c938a8f34853d31cada7e67a

Yes, Joonyoung, can you refresh this against my latest tree and resend
anything that is still needed in this series?

thanks,

greg k-h
