Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754487Ab3BELl3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 06:41:29 -0500
Received: from bar.sig21.net ([80.81.252.164]:38407 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751146Ab3BELl0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 06:41:26 -0500
Date: Tue, 5 Feb 2013 12:39:29 +0100
From: Johannes Stezenbach <js@sig21.net>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: "Markus F.X.J. Oberhumer" <markus@oberhumer.com>,
        Nicolas Pitre <nico@fluxnic.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kyungsik Lee <kyungsik.lee@lge.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Michal Marek <mmarek@suse.cz>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org, x86@kernel.org,
        Nitin Gupta <nitingupta910@gmail.com>,
        Richard Purdie <rpurdie@openedhand.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Joe Millenbach <jmillenbach@gmail.com>,
        Albin Tonnerre <albin.tonnerre@free-electrons.com>, hyojun.im@lge.com,
        chan.jeong@lge.com, gunho.lee@lge.com, minchan.kim@lge.com,
        namhyung.kim@lge.com, raphael.andy.lee@gmail.com,
        CE Linux Developers List <celinux-dev@lists.celinuxforum.org>
Subject: Re: [RFC PATCH 0/4] Add support for LZ4-compressed kernels
Message-ID: <20130205113929.GA18049@sig21.net>
References: <1359179447-31118-1-git-send-email-kyungsik.lee@lge.com>
 <20130128142510.68092e10.akpm@linux-foundation.org>
 <alpine.LFD.2.02.1301282320430.6300@xanadu.home>
 <20130130102353.GA8925@sig21.net>
 <510F16C9.2060901@oberhumer.com>
 <20130204105052.GA17786@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130204105052.GA17786@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-21-Score: -2.9 (--)
X-Spam-21-Report: No, score=-2.9 required=8.0 tests=ALL_TRUSTED=-1,BAYES_00=-1.9 autolearn=ham
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 04, 2013 at 10:50:52AM +0000, Russell King - ARM Linux wrote:
> On Mon, Feb 04, 2013 at 03:02:49AM +0100, Markus F.X.J. Oberhumer wrote:
> > At least akpm did approve the LZO update for inclusion into 3.7, but the code
> > still has not been merged into the main tree.
> >   > On 2012-10-09 21:26, Andrew Morton wrote:
> >   > [...]
> >   > The changes look OK to me.  Please ask Stephen to include the tree in
> >   > linux-next, for a 3.7 merge.
> > 
> > Well, this probably means I have done a rather poor marketing.
> 
> I assume this code is sitting in *your* tree?  How do you think it gets
> into mainline?
> 
> There is no automatic way that code from linux-next gets merged into
> mainline.  That is up to the tree owner to make happen, either by getting
> their tree into a parent maintainers tree, or if there is none, asking
> Linus to pull your tree at the appropriate time.

My feeling is that in this case it is unneccessarily hard
for an outside contributor to get a patch accepted, all
because get_maintainer.pl doesn't put someone in charge.

Apparently it doesn't work to put all the usual maintainer
responsibilities onto the shoulders of a Linux development novice.
Thus it would be nice if some maintainer would come
forward and offer to handle the patches for Markus.


Thanks,
Johannes
