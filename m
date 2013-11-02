Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754323Ab3KBTzO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Nov 2013 15:55:14 -0400
Received: from cpsmtpb-ews10.kpnxchange.com ([213.75.39.15]:49265 "EHLO
	cpsmtpb-ews10.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753262Ab3KBTzL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Nov 2013 15:55:11 -0400
Message-ID: <1383422109.4378.15.camel@x220.thuisdomein>
Subject: Re: [kconfig] update: results of some syntactical checks
From: Paul Bolle <pebolle@tiscali.nl>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Martin Walch <walch.martin@web.de>, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Larry Finger <Larry.Finger@lwfinger.net>, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org
Date: Sat, 02 Nov 2013 20:55:09 +0100
In-Reply-To: <20131102174047.70c24ed8@samsung.com>
References: <3513955.N5RNgL3hPx@tacticalops>
	 <1383420054.4378.3.camel@x220.thuisdomein>
	 <20131102174047.70c24ed8@samsung.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 Nov 2013 19:55:09.0808 (UTC) FILETIME=[6F8A1700:01CED805]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-11-02 at 17:40 -0200, Mauro Carvalho Chehab wrote:
> Em Sat, 02 Nov 2013 20:20:54 +0100
> Paul Bolle <pebolle@tiscali.nl> escreveu:
> > Those are obvious typos. Still present in v3.12-rc7. Perhaps you'd like
> > to send the trivial patch to fix this?
> 
> Yes, it is a typo...
> 
> > > Probably, it was meant to say something like
> > > >	depends on SMS_USB_DRV = SMS_SDIO_DRV
> 
> But this is not the right thing to do. The Kconfig logic here is that it
> should depends on !SMS_SDIO_DRV or SMS_USB_DRV = SMS_SDIO_DRV.

For the record: my reason for suggesting to Martin to send patches is
that sending a (trivial) patch often turns out to be a quick way to get
issues like that resolved. Maintainers seem to react quite quickly on
patches. Perhaps even faster if a patch is not solving the issue at hand
entirely correct! Messages like Martin's, that basically state that
there are one or more tree-wide problems, seem to be overlooked easily.

> I remember I made a patch like that while testing some things with this
> driver, but it seems that I forgot to push. I might have it somewhere on
> my test machine.


Paul Bolle

