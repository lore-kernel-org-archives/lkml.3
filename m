Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754407Ab3C3Vmc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Mar 2013 17:42:32 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:57221 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752679Ab3C3Vmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Mar 2013 17:42:31 -0400
Date: Sat, 30 Mar 2013 22:42:29 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Anton Vorontsov <anton@enomsg.org>
Cc: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        Joerg Reisenweber <joerg@openmoko.org>,
        Ivaylo Dimitrov <freemangordon@abv.bg>
Subject: Re: [PATCH v2] New Nokia RX-51 power supply battery driver
Message-ID: <20130330214229.GA4322@amd.pavel.ucw.cz>
References: <19040462.WFXWijAIDd@pali>
 <20121030223922.GA29061@lizard>
 <2562836.SjVVyiPAk1@pali>
 <20130330180705.GE28947@amd.pavel.ucw.cz>
 <20130330183526.GA21198@lizard>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130330183526.GA21198@lizard>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2013-03-30 11:35:26, Anton Vorontsov wrote:
> On Sat, Mar 30, 2013 at 07:07:05PM +0100, Pavel Machek wrote:
> > On Wed 2012-10-31 10:48:40, Pali Rohár wrote:
> > > Hello, I fixed style issues and added it to Makefile and Kconfig.
> > > 
> > > power_supply: Add Nokia RX-51 battery driver
> > > 
> > > This driver exporting battery design capacity, temperature and voltage
> > > for battery in Nokia RX-51. This driver is needed for open source
> > > battery management on Nokia RX-51 (N900).
> > > 
> > > Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
> > 
> > Reviewed-by: Pavel Machek <pavel@ucw.cz>
> 
> Thanks for the review, Pavel! Although, the patch is in Linus' tree long
> ago. ;-)

Yeah... I did a bit of history-digging ;-). Now, I should figure out
how to put custom kernel on n900 _and_ keep it in working state at the
same time.

(I installed some kind of multiboot, then, apt decided to install some
u-boot extension. Then it got interesting. I never got my own kernel
to work, and u-boot magically disappeared, but I still have working
phone :-).

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
