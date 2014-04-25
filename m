Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753641AbaDYLks (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 07:40:48 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:58722 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753546AbaDYLkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 07:40:41 -0400
Date: Fri, 25 Apr 2014 12:40:17 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Yegor Yefremov <yegorslists@googlemail.com>
Cc: NeilBrown <neilb@suse.de>, balbi@ti.com, Nishanth Menon <nm@ti.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Marcel Holtmann <marcel@holtmann.org>, gustavo@padovan.org,
        johan.hedberg@gmail.com, jslaby@suse.cz,
        Grant Likely <grant.likely@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-bluetooth@vger.kernel.org, linux-serial@vger.kernel.org,
        devicetree@vger.kernel.org,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH 10/13] tty: serial: omap: remove some dead code
Message-ID: <20140425124017.6fbcb971@alan.etchedpixels.co.uk>
In-Reply-To: <CAGm1_kvSEcXRGoQrUoJcmFq6gTHkjupzDqesw3cTmL=V74yPOw@mail.gmail.com>
References: <1398265117-11793-1-git-send-email-balbi@ti.com>
	<1398265117-11793-10-git-send-email-balbi@ti.com>
	<5357DDA8.4040206@ti.com>
	<20140424084305.20c7f301@notabene.brown>
	<20140423230121.GC10924@saruman.home>
	<20140424101329.02e6a62f@notabene.brown>
	<20140424012100.GB13374@saruman.home>
	<20140424151914.6bc6463a@alan.etchedpixels.co.uk>
	<20140425193412.7d32e429@notabene.brown>
	<CAGm1_kvSEcXRGoQrUoJcmFq6gTHkjupzDqesw3cTmL=V74yPOw@mail.gmail.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> As soon as this patch
> (http://www.spinics.net/lists/arm-kernel/msg325197.html) will be
> applied, we don't really need this DTR GPIO any more.

For the omap specific case, not for the general case of sorting out power
hierarchies.

Alan
