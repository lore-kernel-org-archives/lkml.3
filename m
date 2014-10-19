Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752406AbaJSX0X (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 19:26:23 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:53273 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752352AbaJSX0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 19:26:22 -0400
Date: Mon, 20 Oct 2014 00:26:17 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Andrew Pinski <pinskia@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel: use the gnu89 standard explicitly
Message-ID: <20141019232617.GL7996@ZenIV.linux.org.uk>
References: <1413734862-13510-1-git-send-email-sasha.levin@oracle.com>
 <CA+55aFyDECoy4s6oO=PFZSyNS_F9EagxFiNm1X95Fu0cdSTeXQ@mail.gmail.com>
 <20141019210348.GA28144@drone.musicnaut.iki.fi>
 <CA+55aFzOYL-2WT2bf5C5ODAJnd=qVgpZGb-6o7z56Vu14wavJg@mail.gmail.com>
 <20141019231031.GB9319@node.dhcp.inet.fi>
 <20141019232124.GC9319@node.dhcp.inet.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141019232124.GC9319@node.dhcp.inet.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 20, 2014 at 02:21:24AM +0300, Kirill A. Shutemov wrote:
> s/C11/C99/
> 
> > 
> > 	(rwlock_t) { .raw_lock = { 0 }, }
> > 
> > as compound literal (which is not constant) rather than constant
> > initalizer plus a cast.
> 
> In some places we can just drop the cast, but it doesn't work everywhere.
> I don't see a way to get pre-c99 semantics here.

I have a moderately bitrotten patchset taking care of that; might make sense
to resurrect it...
