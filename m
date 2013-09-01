Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757587Ab3IAQza (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 12:55:30 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:50700 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753620Ab3IAQz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 12:55:28 -0400
Date: Sun, 1 Sep 2013 17:55:25 +0100
From: Gustavo Padovan <gustavo@padovan.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: marcel@holtmann.org, johan.hedberg@gmail.com,
        linux-bluetooth@vger.kernel.org,
        kernel list <linux-kernel@vger.kernel.org>
Subject: Re: 3.11-rc7: unpriviledged user crashes kernel using bluetooth
Message-ID: <20130901165525.GK7440@joana>
Mail-Followup-To: Gustavo Padovan <gustavo@padovan.org>,
	Pavel Machek <pavel@ucw.cz>, marcel@holtmann.org,
	johan.hedberg@gmail.com, linux-bluetooth@vger.kernel.org,
	kernel list <linux-kernel@vger.kernel.org>
References: <20130831100127.GA6711@amd.pavel.ucw.cz>
 <20130831100933.GA7029@amd.pavel.ucw.cz>
 <20130831101451.GC7029@amd.pavel.ucw.cz>
 <20130831104238.GA7767@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130831104238.GA7767@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel,

2013-08-31 Pavel Machek <pavel@ucw.cz>:

> On Sat 2013-08-31 12:14:51, Pavel Machek wrote:
> > On Sat 2013-08-31 12:09:33, Pavel Machek wrote:
> > > Hi!
> > > 
> > > > . Python sources for client/server are at 
> > > > 
> > > > http://tui.cvs.sourceforge.net/viewvc/tui/tui/liveview/
> > > > 
> > > > . My kernels like to warn about
> > > System is debian stable with gnome2.
> > 
> > And no, it is not fixed in 3.11-rc7.
> 
> 2.6.32-5-686 from debian seems to work.

Could you try linux-next? We recently pushed a rework of the RFCOMM tty
handling, it should fix this. The work was too big to be pushed to 3.11

	Gustavo
