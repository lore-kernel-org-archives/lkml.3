Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755303AbaJULBY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 07:01:24 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:35385 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754969AbaJULBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 07:01:23 -0400
Date: Tue, 21 Oct 2014 13:01:20 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Nick Dyer <nick.dyer@itdev.co.uk>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Greg KH <greg@kroah.com>,
        Jonathan Cameron <jic23@kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Touch processing on host CPU
Message-ID: <20141021110120.GD23161@amd>
References: <5440F282.8040306@itdev.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5440F282.8040306@itdev.co.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!


> I'm trying to find out which subsystem maintainer I should be talking to -
> apologies if I'm addressing the wrong people.
> 
> There is a model for doing touch processing where the touch controller
> becomes a much simpler device which sends out raw acquisitions (over SPI 
> at up to 1Mbps + protocol overheads). All touch processing is then done in
> user space by the host CPU. An example of this is NVIDIA DirectTouch - see:
> http://blogs.nvidia.com/blog/2012/02/24/industry-adopts-nvidia-directtouch/

Would it be possible to do processing in kernel space?

> In the spirit of "upstream first", I'm trying to figure out how to get a
> driver accepted. Obviously it's not an input device in the normal sense. Is
> it acceptable just to send the raw touch data out via a char device?
> Is

Char device would be best option if not.

> there another subsystem which is a good match (eg IIO)? Does the protocol
> (there is ancillary/control data as well) need to be documented?

It really depends. If you have driver for serial port, you don't need
to describe what goes over the serial port. But documentation would be
nice.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
