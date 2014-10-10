Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754219AbaJJNgo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 09:36:44 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:57865 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753074AbaJJNgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 09:36:41 -0400
Date: Fri, 10 Oct 2014 15:36:35 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Norbert Preining <preining@logic.at>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-kernel@vger.kernel.org
Subject: Re: /dev/root changes with 3.17-rc
Message-ID: <20141010133635.GA31817@Nokia-N900>
References: <20140911144510.GK22037@auth.logic.tuwien.ac.at>
 <20141010124012.GA27653@amd>
 <20141010125257.GJ11697@auth.logic.tuwien.ac.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141010125257.GJ11697@auth.logic.tuwien.ac.at>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2014-10-10 21:52:57, Norbert Preining wrote:
> On Fri, 10 Oct 2014, Pavel Machek wrote:
> > > I am not sure whether this is a kernel bug, but:
> > > - booting with 3.16 I get
> > > 	/ mounted on /dev/sda6
> > > - booting with 3.17-rc* I get
> > > 	/ mounted on /dev/root
> > 
> > Where do you see the this? /proc/mounts?
> 
> After loads of testing I found out what is the problem: initramfs.
> 
> I normally compile my own kernel with all the drivers built-in,
> and no initramfs ... and in this case, without initrd, it seems that
> / is somehow not remounted to a proper scsi device, but remains 
> at /dev/root.

But that was always the case, no? Yes, it would be nice to
print real root device name in /proc/mounts, but it was
"broken" for as far as I can remember...
							Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
