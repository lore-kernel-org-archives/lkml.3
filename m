Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755176AbaGKT2t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 15:28:49 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:38054 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754071AbaGKT2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 15:28:47 -0400
Date: Fri, 11 Jul 2014 21:28:45 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        Rob Herring <robherring2@gmail.com>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Sebastian Reichel <sre@debian.org>, Will Deacon <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] ARM: /proc/cpuinfo: Use DT machine name when possible
Message-ID: <20140711192845.GB20015@amd.pavel.ucw.cz>
References: <1403110464-29646-1-git-send-email-pali.rohar@gmail.com>
 <CAL_JsqKw-C6uZBU3hccGmdofXcCcUKTV6z7Af6KwYwnZiy3HoQ@mail.gmail.com>
 <201406182122.29623@pali>
 <20140618211038.GD558@drone.musicnaut.iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140618211038.GD558@drone.musicnaut.iki.fi>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2014-06-19 00:10:39, Aaro Koskinen wrote:
> Hi,
> 
> On Wed, Jun 18, 2014 at 09:22:29PM +0200, Pali Rohár wrote:
> > So without this patch DT migration for Nokia N900 cannot be done 
> > without breaking userspace - which is not acceptable...
> 
> I guess the fact is that the Nokia N900 proprietary userspace has
> never worked properly with the mainline kernel without severe patching,
> so you cannot really talk about any regression. If you cannot fix
> those programs, you could still probably emulate the old Nokia kernel's
> /proc/cpuinfo by providing some text file and bind mounting it, no?

Actually, yes, it worked pretty well with some close-to-mainline
kernels.

And bind-mount on /proc/cpuinfo is beyond ugly, don't you think?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
