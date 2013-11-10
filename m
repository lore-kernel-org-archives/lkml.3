Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758629Ab3KJENt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 23:13:49 -0500
Received: from linux-libre.fsfla.org ([208.118.235.54]:39311 "EHLO
	linux-libre.fsfla.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758588Ab3KJENs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 23:13:48 -0500
From: Alexandre Oliva <oliva@gnu.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.12 released .. and no merge window yet .. and 4.0 plans?
In-Reply-To: <CA+55aFwLkvSkparyvekdmMyvr6Srw1KkzTBp=_w0oQRWnPpJug@mail.gmail.com>
	(Linus Torvalds's message of "Sun, 3 Nov 2013 16:10:59 -0800")
Organization: Free thinker, not speaking for the GNU Project
References: <CA+55aFwLkvSkparyvekdmMyvr6Srw1KkzTBp=_w0oQRWnPpJug@mail.gmail.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
Date: Sun, 10 Nov 2013 02:13:20 -0200
Message-ID: <ortxfksxlr.fsf@livre.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov  3, 2013, Linus Torvalds <torvalds@linux-foundation.org> wrote:

> we'll have 4.0 follow 3.19 or something like that.

> we could do a release with just stability and bug-fixes

> the reason I mention "4.0" is that it would be a lovely time to do
> that.

That sounds backwards.  .0s are known for instability and major new
features that justify the major version number bump.  A fixes-only
release would make more sense as a last breath of the 3.* series, before
(or even after?) 4.0 comes out.

One way this might work is with a shorter release cycle after 3.19, with
a fixes-only merge window, which would lead to a shorter stabilization
cycle than usual, a rock-solid 3.20 release at the end of that cycle,
during which new features would presumably have piled up for longer than
usual, so as to make for more new features in the subsequent merge
window, which would then justify a bump to 4.0.

The shorter cycle towards 3.20, which would make the 2 cycles towards
4.0 shorter than two usual cycles, may help relieve some of the pressure
to get features into 3.19, since the merge window for 4.0 won't be that
far off.

-- 
Alexandre Oliva, freedom fighter    http://FSFLA.org/~lxoliva/
You must be the change you wish to see in the world. -- Gandhi
Be Free! -- http://FSFLA.org/   FSF Latin America board member
Free Software Evangelist      Red Hat Brazil Compiler Engineer
