Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754062Ab3BDK5n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 05:57:43 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:34606 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613Ab3BDK5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 05:57:42 -0500
Date: Mon, 4 Feb 2013 10:50:52 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: "Markus F.X.J. Oberhumer" <markus@oberhumer.com>
Cc: Johannes Stezenbach <js@sig21.net>, Nicolas Pitre <nico@fluxnic.net>,
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
Message-ID: <20130204105052.GA17786@n2100.arm.linux.org.uk>
References: <1359179447-31118-1-git-send-email-kyungsik.lee@lge.com> <20130128142510.68092e10.akpm@linux-foundation.org> <alpine.LFD.2.02.1301282320430.6300@xanadu.home> <20130130102353.GA8925@sig21.net> <510F16C9.2060901@oberhumer.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <510F16C9.2060901@oberhumer.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 04, 2013 at 03:02:49AM +0100, Markus F.X.J. Oberhumer wrote:
> At least akpm did approve the LZO update for inclusion into 3.7, but the code
> still has not been merged into the main tree.
>   > On 2012-10-09 21:26, Andrew Morton wrote:
>   > [...]
>   > The changes look OK to me.  Please ask Stephen to include the tree in
>   > linux-next, for a 3.7 merge.
> 
> Well, this probably means I have done a rather poor marketing.

I assume this code is sitting in *your* tree?  How do you think it gets
into mainline?

There is no automatic way that code from linux-next gets merged into
mainline.  That is up to the tree owner to make happen, either by getting
their tree into a parent maintainers tree, or if there is none, asking
Linus to pull your tree at the appropriate time.
