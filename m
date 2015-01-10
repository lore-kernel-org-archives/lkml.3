Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753467AbbAJSFf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 13:05:35 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:47103 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751201AbbAJSFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 13:05:34 -0500
X-Sasl-enc: 299WrM/nEtVE054eVyZMom4kufROotmmfb+z2N08B1/p 1420913133
Date: Sat, 10 Jan 2015 10:05:32 -0800
From: Greg KH <greg@kroah.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: pali.rohar@gmail.com, sre@debian.org, sre@ring0.de,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        khilman@kernel.org, aaro.koskinen@iki.fi, ivo.g.dimitrov.75@gmail.com
Subject: Re: Getting new udev to run with 2.6.28
Message-ID: <20150110180532.GA8566@kroah.com>
References: <20150110173920.GA31847@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150110173920.GA31847@amd>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 10, 2015 at 06:39:20PM +0100, Pavel Machek wrote:
> Hi!
> 
> N900 has real problems on 3.19, and 2.6.28 should be very well
> debugged version. Getting it to compile on recent distribution was
> fun, but I succeeded. Unfortunately, Debian 7's udev does not work
> with 2.6.28...
> 
> Does anyone have kernel patches to enable modern udev?

Yes, 3.18, please use that instead.

Seriously, lots of things have changed, if you want to run a "new"
version of udev with an old kernel, try eudev, they have been attempting
to keep "legacy" support around in it, don't know how well it has been
working though, you really are on your own.
