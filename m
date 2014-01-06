Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756232AbaAFVLS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 16:11:18 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:47752 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755635AbaAFVLQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 16:11:16 -0500
Date: Mon, 6 Jan 2014 22:11:15 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Ramkumar Ramachandra <artagnon@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [QUERY] Power consumption on a 2013 MBP
Message-ID: <20140106211115.GA23421@amd.pavel.ucw.cz>
References: <CALkWK0n0q+a9EmMbJXsgo6eO1B+0Lq6tqsN3moLbXz+Y0GGu0g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALkWK0n0q+a9EmMbJXsgo6eO1B+0Lq6tqsN3moLbXz+Y0GGu0g@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2013-12-31 15:24:00, Ramkumar Ramachandra wrote:
> Hi,
> 
> On a 2013 Macbook Pro, Linux consumes 21W of power while OS X consumes
> just 9W. I found this very disturbing; Linux more than halves the
> battery life of the device. I checked to see that I wasn't running any
> especially power-hungry applications or drivers (using powertop). I'm
> using just one proprietary driver: the broadcom-wl wireless driver;
> otherwise, I'm running the stock 3.12 kernel from Arch's repositories.
> 
> How do I figure out what is consuming power, and what can I do to help
> minimize consumption?

USB usually does that. Try rmmoding hcd(s). If that does not help, try
removing other modules. Oh and try without that broadcom-wl driver.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
