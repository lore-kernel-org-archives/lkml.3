Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934182Ab3BMUE0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 15:04:26 -0500
Received: from awesome.dsw2k3.info ([195.71.86.230]:59386 "EHLO
	awesome.dsw2k3.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821Ab3BMUEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 15:04:24 -0500
Date: Wed, 13 Feb 2013 21:04:13 +0100
From: Matthias Schniedermeyer <ms@citd.de>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Holger =?iso-8859-1?Q?Hoffst=E4tte?= 
	<holger.hoffstaette@googlemail.com>,
        Jonathan Nieder <jrnieder@gmail.com>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Greg KH <gregkh@linuxfoundation.org>, Tilman Schmidt <tilman@imap.cc>
Subject: Re: [regression] external HDD in USB3 enclosure cannot be
 dynamically removed (Re: Linux 3.7.5)
Message-ID: <20130213200413.GA17648@citd.de>
References: <pan.2013.01.28.11.42.16.556318@googlemail.com>
 <20130128143907.GA2940@kroah.com>
 <pan.2013.01.28.20.33.44.918987@googlemail.com>
 <20130128204639.GB7759@google.com>
 <20130212004023.GA8427@xanatos>
 <511A1AF1.9080107@googlemail.com>
 <20130212204224.GC8427@xanatos>
 <511B4EB1.9010708@googlemail.com>
 <20130213171656.GA9318@citd.de>
 <20130213193303.GH8427@xanatos>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="gBBFr7Ir9EOA20Yy"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130213193303.GH8427@xanatos>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gBBFr7Ir9EOA20Yy
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On 13.02.2013 11:33, Sarah Sharp wrote:
> On Wed, Feb 13, 2013 at 06:16:56PM +0100, Matthias Schniedermeyer wrote:
> > On 13.02.2013 09:28, Holger Hoffstätte wrote:
> > > On 12.02.2013 21:42, Sarah Sharp wrote:
> > > > [..]
> > > > There was a further set of patches queued for 3.9 to deal with connected
> > > > devices going to the Inactive state, but they looked like they were too
> > > > big for stable:
> > > > 
> > > > d3b9d7a USB: Fix connected device switch to Inactive state.
> > > > a24a607 USB: Rip out recursive call on warm port reset.
> > > > 2d4fa94 USB: Prepare for refactoring by adding extra udev checks.
> > > > 0fe51aa USB: Don't use EHCI port sempahore for USB 3.0 hubs.
> > > > 
> > > > Can you retry with Greg's usb-next branch?
> > > > 
> > > > git clone git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git -b usb-next
> > > > 
> > > > If that fixes your problem, we should either get those additional
> > > > patches into 3.8 and the stable trees, or do a revert of the whole
> > > > series and just let 3.9 carry the full patchset.
> > > 
> > > Good news! This one does indeed work as expected - the device can be
> > > removed and is gone for good. Upstream & Stable plz :)
> > 
> > That kernel fixes the problem for me too.
> 
> Great!
> 
> Holger and Matthias, can you double check that cherry picking just those
> four patches on top of 3.7.7 or 3.8 works as well?

3.7.7 + those 4 patches workes for me.

As i'm not very firm in git i generated separate diffs for each commit 
and applying them in the order 2d4fa94 0fe51aa d3b9d7a a24a607 worked 
without hunks dropped.

I have attached `git diff` against vanilla 3.7.7, so you can check that 
i got it right.




-- 

Matthias

--gBBFr7Ir9EOA20Yy
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="combined.diff.gz"
Content-Transfer-Encoding: base64

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
ixZJ+a7iqQuXq9dmJ3pPIa/onw+9zsvLHQAA

--gBBFr7Ir9EOA20Yy--
