Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752724Ab3BUAHW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 19:07:22 -0500
Received: from mail-pb0-f42.google.com ([209.85.160.42]:44478 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144Ab3BUAHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 19:07:19 -0500
Date: Wed, 20 Feb 2013 16:07:49 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: Wonky PS2-USB converter issues...
Message-ID: <20130221000749.GC14395@kroah.com>
References: <21767.1361400518@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <21767.1361400518@turing-police.cc.vt.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2013 at 05:48:38PM -0500, Valdis Kletnieks wrote:
> Quite some time ago, I posted about a problematic PS2-USB converter
> that I used to connect an old PS2-connector keyboard to my laptop
> dock, where the keyboard wouldn't be recognized at boot unless
> I unplugged and reconnected it.
> 
> Well, I've recently figured out (partly by obtaining a converter
> from a different vendor) that the converters both work correctly
> when plugged into a USB port that's physically on my Dell Latitude
> laptop - but they have issues and require a reconnect cycle when
> plugged into the docking station for the laptop. (It took a long time
> to figure this out, because *of course* you plug this sort of stuff
> into the docking station specifically so you don't have to plug it
> in every morning).
> 
> So obviously, it isn't the converter that is the problem, but the docking
> station is doing "something stupid".  Anybody have suggestions on figuring out
> what it's doing wrong?

PS-2 connectors can not normally handle hotplugging, the protocol
doesn't allow it, and for some unlucky devices, it could actually fry
the motherboard or the PS-2 device.

So that's probably the issue here, the device just doesn't support it,
sorry.

greg k-h
