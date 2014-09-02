Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753360AbaIBJP3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 05:15:29 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33027 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752076AbaIBJP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 05:15:27 -0400
Message-ID: <1409649317.4449.7.camel@paszta.hi.pengutronix.de>
Subject: Re: [PATCH 1/2] gpu: ipu-v3: Select GENERIC_IRQ_CHIP to fix build
 error
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Axel Lin <axel.lin@ingics.com>
Cc: Lucas Stach <l.stach@pengutronix.de>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 02 Sep 2014 11:15:17 +0200
In-Reply-To: <20140902032849.GA9056@kroah.com>
References: <1407033419.17812.2.camel@phoenix>
	 <CAFRkauB=2f5-zN5OAwx0LSYSnwuub_ONL+LuYYdy6-MxWQNzLw@mail.gmail.com>
	 <20140902021119.GA2525@kroah.com>
	 <CAFRkauB3gcNjP-3_kvbYS6Zi3p1QwHsZs6SkPOLE-LAbpb=uyQ@mail.gmail.com>
	 <20140902032849.GA9056@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:96de:80ff:fec2:9969
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Am Montag, den 01.09.2014, 20:28 -0700 schrieb Greg Kroah-Hartman:
[...]
> > I checked the MAINTAINERS file,
> > I can only find the maintainer for some subfolders of drivers/gpu but no entry
> > for drivers/gpu/ipu-v3.
> > So I'm not sure who is the maintainer for drivers/gpu/ipu-v3.
> 
> Who moved the file out of staging?  I don't think it was me...
>
> I think it is Philipp, who sent the patches through the drm tree, so try
> those developers.

I'll collect gpu/ipu-v3 patches and send them on.
I've pushed this patch to:

git://git.pengutronix.de/git/pza/linux.git topic/ipu-fixes

regards
Philipp

