Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520AbaCJO0S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 10:26:18 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:58348 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753103AbaCJO0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 10:26:15 -0400
Date: Mon, 10 Mar 2014 14:25:31 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: David Miller <davem@davemloft.net>, rob@landley.net, andrew@lunn.ch,
        f.fainelli@gmail.com, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: phy: Add sysfs attribute to prevent PHY suspend
Message-ID: <20140310142531.1fde5797@alan.etchedpixels.co.uk>
In-Reply-To: <531D0D0D.4050703@gmail.com>
References: <531CF864.9040406@gmail.com>
	<20140309.203001.1318893833441564547.davem@davemloft.net>
	<531D094C.1090205@gmail.com>
	<20140309.204101.47552917508273123.davem@davemloft.net>
	<531D0D0D.4050703@gmail.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Mar 2014 01:53:33 +0100
Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com> wrote:

> On 03/10/2014 01:41 AM, David Miller wrote:
> > From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> > Date: Mon, 10 Mar 2014 01:37:32 +0100
> >
> >> The mechanism is manual, no automatic way to determine it.
> >
> > We recognize BIOS and ACPI bugs and work around them, by looking at
> > version information and whatnot, so you really can't convince me that
> > something similar can't be done here perhaps in the platform code.
> 
> Hmm, if the is a way to determine the version of that particual u-boot
> I'd be happy to exploit that information.

If there isn't a way for a kernel to determine the U-boot version then
maybe that should get fixed instead. That also solves your problem
because if you can't find the uboot version you know its too old.

Alan
