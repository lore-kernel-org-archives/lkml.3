Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757606Ab3KLWNe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 17:13:34 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:51426 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756722Ab3KLWN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 17:13:27 -0500
Date: Tue, 12 Nov 2013 23:13:25 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Aldo Iljazi <mail@aldo.io>
Cc: andreas.thalhammer@linux.com, linux-kernel@vger.kernel.org
Subject: Re: A Desktop Linux idea: modulized open hardware database for the
 linux kernel config
Message-ID: <20131112221325.GA12391@amd.pavel.ucw.cz>
References: <201311031553.26488.andreas.thalhammer@linux.com>
 <20131103161819.GA4983@linux>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131103161819.GA4983@linux>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> So, you are saying that this should be available for power users only,
> since it requires kernel compilation.
> 
> I have a few points to make.
> 
> 1. Wouldn't power users know how to configure the kernel anyway for
> their system?

No, not really. Getting configuration to work is always interesting...

> 2. What about future hardware upgrades (on both a laptop and desktop
> machines).
> 
> 3. What's wrong with stock distribution kernels?

Actually, biggest problem with configurations for various non-PC
systems like Nokia N900 or Zaurus (where distributions does not work).

> 4. Wouldn't this take a great amount of manpower for I guess minimum
> benefits?

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
