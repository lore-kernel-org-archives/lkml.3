Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752957AbaBSKFx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 05:05:53 -0500
Received: from mail1.bemta3.messagelabs.com ([195.245.230.174]:42184 "EHLO
	mail1.bemta3.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752529AbaBSKFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 05:05:48 -0500
X-Env-Sender: Johannes.Thumshirn@men.de
X-Msg-Ref: server-16.tower-39.messagelabs.com!1392804344!12202422!1
X-Originating-IP: [80.255.6.145]
X-StarScan-Received: 
X-StarScan-Version: 6.9.16; banners=-,-,-
X-VirusChecked: Checked
X-PGP-Universal: processed;
	by keys.men.de on Wed, 19 Feb 2014 11:05:44 +0100
Date: Wed, 19 Feb 2014 11:05:42 +0100
From: Johannes Thumshirn <johannes.thumshirn@men.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Johannes Thumshirn <johannes.thumshirn@men.de>,
        Jonathan Cameron <jic23@kernel.org>, <linux-iio@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Josh Cartwright <joshc@codeaurora.org>
Subject: Re: [PATCH 1/3] drivers: Introduce MEN Chameleon Bus
Message-ID: <20140219100542.GC16649@jtlinux>
References: <1392737654-22682-1-git-send-email-johannes.thumshirn@men.de>
 <1392737654-22682-2-git-send-email-johannes.thumshirn@men.de>
 <20140218214819.GA20495@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140218214819.GA20495@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [192.1.1.31]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 18, 2014 at 01:48:19PM -0800, Greg Kroah-Hartman wrote:
> On Tue, Feb 18, 2014 at 04:34:12PM +0100, Johannes Thumshirn wrote:
> > The MCB (MEN Chameleon Bus) is a Bus specific to MEN Mikroelektronik
> > FPGA based devices. It is used to identify MCB based IP-Cores within
> > an FPGA and provide the necessary framework for instantiating drivers
> > for these devices.
> >
> > Signed-off-by: Johannes Thumshirn <johannes.thumshirn@men.de>
>
> Looks good to me, nice job with the driver core integration.
>

Thanks.

> Want me to queue this up through my tree?  Or do you want to have it go
> through somewhere else?
>

I don't really care. If you want to take it, I'd be pleased. On the other hand
PATCH 3/3 is a IIO driver, which depends on the other 2 patches, so I could be
better to take this via the IIO tree. I don't know which is better.

But apart from that, I first want/need to work in Josh Cartwright's comments,
but this could be delayed till monday, sorry.

Thanks,
Johannes
