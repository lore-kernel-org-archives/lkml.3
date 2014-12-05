Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751831AbaLEUl1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 15:41:27 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:60050 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172AbaLEUlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 15:41:25 -0500
Date: Fri, 5 Dec 2014 21:41:22 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Darren Hart <dvhart@infradead.org>,
        Gabriele Mazzotta <gabriele.mzt@gmail.com>, mjg59@srcf.ucam.org,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] dell-wmi: Don't send unneeded keypresses
Message-ID: <20141205204122.GA11772@amd>
References: <1417648583-9336-1-git-send-email-gabriele.mzt@gmail.com>
 <20141203133431.GG75099@vmdeb7>
 <201412052131.34455@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201412052131.34455@pali>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2014-12-05 21:31:34, Pali Rohár wrote:
> On Wednesday 03 December 2014 14:34:32 Darren Hart wrote:
> > On Thu, Dec 04, 2014 at 12:16:20AM +0100, Gabriele Mazzotta 
> wrote:
> > > Currently dell-wmi reports keypresses for WMI events that
> > > are notifications of changes performed by the BIOS.
> > > This patch series make sure that no keypresses are sent for
> > > those events so that nothing is done from userspace.
> > > 
> > > Gabriele Mazzotta (3):
> > >   dell-wmi: Use appropriate keycode for radio state changes
> > >   dell-wmi: Don't report keypresses for radio state changes
> > 
> > Merged into one patch, queued.
> > 
> > >   dell-wmi: Don't report keypresses on keybord illumination
> > >   change
> > 
> > Queued.
> > 
> > Thanks Gabriele.
> 
> Darren, what do you think about sending patch into stable kernel?

I'd suggest against that. -stable is for "serious" bugs, and we don't
want to change this kind of behaviour in -stable kernel.

								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
