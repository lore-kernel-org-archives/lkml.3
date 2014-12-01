Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933072AbaLAXYD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 18:24:03 -0500
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:40004 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932700AbaLAXYA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 18:24:00 -0500
X-Greylist: delayed 607 seconds by postgrey-1.27 at vger.kernel.org; Mon, 01 Dec 2014 18:24:00 EST
Date: Tue, 2 Dec 2014 01:13:38 +0200
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: Tony Lindgren <tony@atomide.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-serial@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Sekhar Nori <nsekhar@ti.com>,
        Felipe Balbi <balbi@ti.com>, uwe@kleine-koenig.org
Subject: Re: [PATCH] tty: serial: serial-omap: depend on !8250_omap
Message-ID: <20141201231338.GA14524@fuloong-minipc.musicnaut.iki.fi>
References: <1417039306-2384-1-git-send-email-bigeasy@linutronix.de>
 <20141129094823.GA10840@linutronix.de>
 <20141129173418.GY2817@atomide.com>
 <20141201140914.728aaa46@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141201140914.728aaa46@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Dec 01, 2014 at 02:09:14PM +0000, One Thousand Gnomes wrote:
> > Well the nightmare userspace switch from ttyS to ttyO few years ago is
> > something we want to avoid.. I think the best solution would be to make
> > serial-omap.c transparently provide support for ttyO using the new 8250
> > code so both ttyS and ttyO devices would just work. Otherwise it will
> > be years of "my serial port stopped working" questions again.
> 
> Thata a udev problem not a kernel one surely.

People also use serial console to observe the early kernel boot before
the userspace is started.

A.
