Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755810AbaEEUoH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 16:44:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50866 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752559AbaEEUoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 16:44:05 -0400
Date: Mon, 5 May 2014 13:47:11 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Johan Hovold <jhovold@gmail.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Felipe Balbi <balbi@ti.com>, Mugunthan V N <mugunthanvnm@ti.com>,
        Tony Lindgren <tony@atomide.com>, bcousson@baylibre.com,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Leigh Brown <leigh@solinno.co.uk>, devicetree@vger.kernel.org
Subject: Re: [PATCH 3.14 012/158] ARM: dts: am33xx: correcting dt node unit
 address for usb
Message-ID: <20140505204711.GC18222@kroah.com>
References: <20140504154029.975081050@linuxfoundation.org>
 <20140504154031.690140742@linuxfoundation.org>
 <20140505083757.GB30739@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140505083757.GB30739@localhost>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 05, 2014 at 10:37:57AM +0200, Johan Hovold wrote:
> On Sun, May 04, 2014 at 11:38:41AM -0400, Greg Kroah-Hartman wrote:
> > 3.14-stable review patch.  If anyone has any objections, please let me know.
> 
> This one should not be backported without commit
> 
> 	a2f8d6b30321 ("ARM: dts: am335x: update USB DT references")
> 
> which is in Linus' tree but is not marked for stable (or USB will be
> disabled for the boards relying on the old node addresses).

Thanks for letting me know, I've now applied that patch as well.

greg k-h
