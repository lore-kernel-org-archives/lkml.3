Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754348Ab3HVVwe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 17:52:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46549 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753733Ab3HVVwd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 17:52:33 -0400
Date: Thu, 22 Aug 2013 14:52:32 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Kamal Mostafa <kamal@canonical.com>, Aaro Koskinen <aaro.koskinen@iki.fi>,
        Luis Henriques <luis.henriques@canonical.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Subject: Re: [3.10][3.8][3.5] ARM: Fix FIQ code on VIVT CPUs (was Re: [PATCH
 076/133] ARM: update FIQ support for relocation of vectors)
Message-ID: <20130822215232.GC28717@kroah.com>
References: <1376692475-28413-1-git-send-email-kamal@canonical.com>
 <1376692475-28413-77-git-send-email-kamal@canonical.com>
 <20130818210952.GI3067@blackmetal.musicnaut.iki.fi>
 <1376928143.18111.12.camel@fourier>
 <20130819160740.GS23006@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130819160740.GS23006@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 19, 2013 at 05:07:41PM +0100, Russell King - ARM Linux wrote:
> On Mon, Aug 19, 2013 at 09:02:23AM -0700, Kamal Mostafa wrote:
> > Thanks Aaro.  I'll apply "2ba85e7 ARM: Fix FIQ code on VIVT CPUs" to
> > 3.8-stable.
> > 
> > Greg KH and Luis Henriques:  Heads up!  3.10-stable and 3.5-stable also
> > need 2ba85e7 but it isn't marked cc: stable.
> 
> There's others from that branch which are probably also needed but I want
> them to sit in -rc for a bit before I request them to move into the stable
> trees - in case anyone finds anything more from the security fixes a while
> back.

Ok, I'll hold off on applying this one until you say it is good to go.

thanks,

greg k-h
