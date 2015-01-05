Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753868AbbAEV2X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 16:28:23 -0500
Received: from 251.110.2.81.in-addr.arpa ([81.2.110.251]:32780 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098AbbAEV2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 16:28:22 -0500
Date: Mon, 5 Jan 2015 21:26:50 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Felipe Balbi <balbi@ti.com>, Aaro Koskinen <aaro.koskinen@iki.fi>,
        Tony Lindgren <tony@atomide.com>, linux-serial@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Sekhar Nori <nsekhar@ti.com>,
        uwe@kleine-koenig.org
Subject: Re: [PATCH] tty: serial: 8250: omap: add ttySx console if the user
 didn't
Message-ID: <20150105212650.701af128@lxorguk.ukuu.org.uk>
In-Reply-To: <20141218174712.GA26632@linutronix.de>
References: <1417039306-2384-1-git-send-email-bigeasy@linutronix.de>
	<20141129094823.GA10840@linutronix.de>
	<20141129173418.GY2817@atomide.com>
	<20141201140914.728aaa46@lxorguk.ukuu.org.uk>
	<20141201231338.GA14524@fuloong-minipc.musicnaut.iki.fi>
	<20141202015118.GA1891@saruman>
	<20141205135133.37fb96f6@lxorguk.ukuu.org.uk>
	<20141218174712.GA26632@linutronix.de>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.24; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Dec 2014 18:47:12 +0100
Sebastian Andrzej Siewior <bigeasy@linutronix.de> wrote:

> This patch invokes add_preferred_console() with ttyS based on ttyO
> arguments if the user didn't specify it on its own. This ensures that
> the user will see the kernel booting on his serial console in case he
> forgot to update the command line.
> 
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

Acked-by: Alan Cox <alan@linux.intel.com>

