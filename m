Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751518AbaBKMp2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 07:45:28 -0500
Received: from cpsmtpb-ews03.kpnxchange.com ([213.75.39.6]:52617 "EHLO
	cpsmtpb-ews03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750758AbaBKMp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 07:45:26 -0500
Message-ID: <1392122724.13064.18.camel@x220>
Subject: Re: [kconfig] update: results of some syntactical checks
From: Paul Bolle <pebolle@tiscali.nl>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Martin Walch <walch.martin@web.de>, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Larry Finger <Larry.Finger@lwfinger.net>, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org
Date: Tue, 11 Feb 2014 13:45:24 +0100
In-Reply-To: <20131102174047.70c24ed8@samsung.com>
References: <3513955.N5RNgL3hPx@tacticalops>
	 <1383420054.4378.3.camel@x220.thuisdomein>
	 <20131102174047.70c24ed8@samsung.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Feb 2014 12:45:25.0232 (UTC) FILETIME=[2274C700:01CF2727]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mauro,

On Sat, 2013-11-02 at 17:40 -0200, Mauro Carvalho Chehab wrote:
> Em Sat, 02 Nov 2013 20:20:54 +0100
> Paul Bolle <pebolle@tiscali.nl> escreveu:
> > On Sun, 2013-10-20 at 00:03 +0200, Martin Walch wrote:
> > > drivers/media/common/siano/Kconfig:21-26
> > > > config SMS_SIANO_DEBUGFS
> > > >	bool "Enable debugfs for smsdvb"
> > > >	depends on SMS_SIANO_MDTV
> > > >	depends on DEBUG_FS
> > > >	depends on SMS_USB_DRV
> > > >	depends on CONFIG_SMS_USB_DRV = CONFIG_SMS_SDIO_DRV
> > > 
> > > The last line adds the dependency CONFIG_SMS_USB_DRV = CONFIG_SMS_SDIO_DRV.
> > > This expression does not look sound as those two symbols are not declared
> > > anywhere. So, the two strings CONFIG_SMS_USB_DRV and CONFIG_SMS_SDIO_DRV
> > > are compared, yielding always 'n'. As a result, SMS_SIANO_DEBUGFS will never
> > > be enabled.
>
> [...] The Kconfig logic here is that it
> should depends on !SMS_SDIO_DRV or SMS_USB_DRV = SMS_SDIO_DRV.
> 
> I remember I made a patch like that while testing some things with this
> driver, but it seems that I forgot to push. I might have it somewhere on
> my test machine.

This line is still present in v3.14-rc2. Did you ever find that patch on
your test machine?


Paul Bolle

