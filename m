Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756684Ab3CQUL3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 16:11:29 -0400
Received: from canardo.mork.no ([148.122.252.1]:49231 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756500Ab3CQUL1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 16:11:27 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Felipe Balbi <balbi@ti.com>, Dongsheng Song <dongsheng.song@gmail.com>,
        Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: Linux 3.8.3
Organization: m
References: <20130314184702.GA17860@kroah.com>
	<CAE8XmWoYXyNFQ14e6X+2rkWQyRA=kSdc4J+DNu2Sv+6e9rvZRg@mail.gmail.com>
	<20130317193321.GA15102@arwen.pp.htv.fi>
	<20130317195709.GC4977@n2100.arm.linux.org.uk>
Date: Sun, 17 Mar 2013 21:10:42 +0100
In-Reply-To: <20130317195709.GC4977@n2100.arm.linux.org.uk> (Russell King's
	message of "Sun, 17 Mar 2013 19:57:10 +0000")
Message-ID: <87ip4p4wjh.fsf@nemi.mork.no>
User-Agent: Gnus/5.11002 (No Gnus v0.20) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King - ARM Linux <linux@arm.linux.org.uk> writes:

> Sigh.
>
> At times, I really don't know why I bother wasting my time commenting on
> patches if they just go and agree with them, and promptly ignore them.
> I pointed out what this should be:
>
> http://marc.info/?l=linux-kernel&m=135972750522902&w=2
>
> And it was agreed:
>
> http://marc.info/?l=linux-kernel&m=135993546317541&w=2
>
> But for some reason the wrong patch got merged:
>
> http://marc.info/?l=git-commits-head&m=136147889001219&w=2
>
> Maybe because it was "simpler" ?  Don't know.  But... well, we now know
> what the outcome of it was.  Let's try a different technique.  I'm going
> to say nothing of any real help and hopefully it will get fixed properly.
> Maybe that'll work.

To be fair, looking at the commitdate of that commit it was already in
Greg's tree when you commented on it.  So the discussion you had would
have to be about a followup-fix to this, and not about that particular
patch.


Bjørn
