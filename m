Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751426Ab3FWJy3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jun 2013 05:54:29 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:49193 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883Ab3FWJy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jun 2013 05:54:27 -0400
Date: Sun, 23 Jun 2013 11:54:25 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Joe Perches <joe@perches.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Shuah Khan <shuah.kh@samsung.com>,
        len.brown@intel.com, gregkh@linuxfoundation.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        shuahkhan@gmail.com
Subject: Re: [PATCHv v3] power: Include additional information in
 pm_print_times
Message-ID: <20130623095425.GB3669@amd.pavel.ucw.cz>
References: <1371497795-20084-1-git-send-email-shuah.kh@samsung.com>
 <2534796.mOHH0DCD2A@vostro.rjw.lan>
 <1371868042.2086.0.camel@joe-AO722>
 <2732229.sfB5fHUFTc@vostro.rjw.lan>
 <1371949550.3137.16.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371949550.3137.16.camel@joe-AO722>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2013-06-22 18:05:50, Joe Perches wrote:
> On Sat, 2013-06-22 at 21:52 +0200, Rafael J. Wysocki wrote:
> > On Friday, June 21, 2013 07:27:22 PM Joe Perches wrote:
> > > On Sat, 2013-06-22 at 02:24 +0200, Rafael J. Wysocki wrote:
> > > > Namely, there are tools that use these messages to create suspend/resume time
> > > > charts and they will stop working after the proposed changes.
> > > 
> > > dmesg output isn't guaranteed to be stable.
> > 
> > So?
> 
> So even if new information was only appended to
> the existing line, the script could break.
> 
> If any script needs something stable it should
> depend on information available through other
> sources like trace or proc or sysfs.

Yeah, people try to add it to debugfs, and the results were not nice.

dmesg output is not stable, but we should not break it unneccessarily;
appending at the end should be fine.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
