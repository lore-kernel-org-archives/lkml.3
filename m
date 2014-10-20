Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751192AbaJTEQz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 00:16:55 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:53451 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798AbaJTEQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 00:16:54 -0400
Date: Mon, 20 Oct 2014 05:16:45 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Sasha Levin <sasha.levin@oracle.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Andrew Pinski <pinskia@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel: use the gnu89 standard explicitly
Message-ID: <20141020041644.GM7996@ZenIV.linux.org.uk>
References: <1413734862-13510-1-git-send-email-sasha.levin@oracle.com>
 <CA+55aFyDECoy4s6oO=PFZSyNS_F9EagxFiNm1X95Fu0cdSTeXQ@mail.gmail.com>
 <20141019210348.GA28144@drone.musicnaut.iki.fi>
 <CA+55aFzOYL-2WT2bf5C5ODAJnd=qVgpZGb-6o7z56Vu14wavJg@mail.gmail.com>
 <20141019231031.GB9319@node.dhcp.inet.fi>
 <CA+55aFxf6_cA5hTtDGqPU4=DkKz_6OUizhiqge+Xf5u34RxeXw@mail.gmail.com>
 <54445079.4000803@oracle.com>
 <CA+55aFwGWbRcrRxnmc7JrEZh+25zNVw7_PqQiCThHr1An=C4_g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwGWbRcrRxnmc7JrEZh+25zNVw7_PqQiCThHr1An=C4_g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 19, 2014 at 05:23:04PM -0700, Linus Torvalds wrote:

> So now we have a *third* semantic of "extern inline", and one that
> seems to be entirely inappropriate to *ever* be used in a header file
> due to duplicate symbol problems. What a mess.
> 
> Maybe we should just specify "gnu89" to avoid these kinds of insane
> semantic changes.

Umm... does anything except alpha really use extern inline?  The instances
outside of arch/alpha seem to be mostly cargo-culting; lib/mpi might be
another one, but other than that...
