Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751426Ab3K3XPf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Nov 2013 18:15:35 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:47132 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196Ab3K3XPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Nov 2013 18:15:33 -0500
Date: Sun, 1 Dec 2013 00:15:32 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: sre@debian.org, sre@ring0.de, kernel list <linux-kernel@vger.kernel.org>
Subject: device-tree based boot on linux-n900 branch
Message-ID: <20131130231532.GA6688@amd.pavel.ucw.cz>
References: <20131127125149.GA9389@amd.pavel.ucw.cz>
 <20131127191320.GA21350@amd.pavel.ucw.cz>
 <201311272044.51906@pali>
 <201311300058.23463@pali>
 <20131130172938.GA5194@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131130172938.GA5194@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2013-11-30 18:29:38, Pavel Machek wrote:
> Hi!
> 
> > > > > Hi, I already have this patch prepared for 3.13.
> > > > 
> > > > Cool :-). Do you plan to publish / is there 3.13 based tree
> > > > I could pull somewhere?
> > > > 
> > > > Thanks,
> > > > 
> > > > 								Pavel
> > > 
> > > Yes, I will rebase n900 patches on top of next 3.13 rc release
> > > which will have some patches already included. I have not
> > > created full n900 3.13 branch yet.
> > 
> > New branch 3.13-rc2 is now on gitorious linux-n900 tree:
> > git://gitorious.org/linux-n900/linux-n900.git
> 
> Branch seems to be named "v3.13-rc2-n900". Thanks!

Is this one expected to boot in devicetree-based setup? If so, does
someone have .config?

Thanks,
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
