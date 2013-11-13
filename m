Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932384Ab3KMRPG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 12:15:06 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:47877 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932324Ab3KMROz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 12:14:55 -0500
Date: Wed, 13 Nov 2013 18:14:44 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Stephan Mueller <smueller@chronox.de>
Cc: Clemens Ladisch <clemens@ladisch.de>, "Theodore Ts'o" <tytso@mit.edu>,
        sandy harris <sandyinchina@gmail.com>, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, Nicholas Mc Guire <der.herr@hofr.at>
Subject: Re: [PATCH] CPU Jitter RNG: inclusion into kernel crypto API and
 /dev/random
Message-ID: <20131113171444.GA4973@amd.pavel.ucw.cz>
References: <2579337.FPgJGgHYdz@tauon>
 <1391779.T98KINxAMQ@myon.chronox.de>
 <528367D0.6010900@ladisch.de>
 <27146362.bQgmetPpTV@tauon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <27146362.bQgmetPpTV@tauon>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >BTW: MFENCE is not guaranteed to flush the instruction pipeline; you
> >need CPUID for that.
> 
> I was not aware of that. Can I simply call the CPUID instruction to read 
> it or do I have to do something special?

Simply call CPUID (warning, it clobbers some registers.).
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
