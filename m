Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754688Ab3AaNHp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 08:07:45 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:60079 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752990Ab3AaNHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 08:07:44 -0500
Date: Thu, 31 Jan 2013 13:07:23 +0000
From: Russell King <rmk@arm.linux.org.uk>
To: Dave Airlie <airlied@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>
Subject: Re: BUG: circular locking dependency detected
Message-ID: <20130131130723.GB32558@flint.arm.linux.org.uk>
References: <CAKMK7uHEggaGfLTq4c3MfY7csQSFpb=kRwdbJUQMN9Cz9K=V4A@mail.gmail.com> <20130130221946.GA14801@flint.arm.linux.org.uk> <CA+55aFyRHK3dmwQf_mdfB18dmoaRZqBG9FvHRqTs7cqBjgUs+g@mail.gmail.com> <CAPM=9tz6YBh2o3T8Ogt4K=wxSrC3Jc4PCJMzfpbyY=B132fA5g@mail.gmail.com> <20130131001339.GC14801@flint.arm.linux.org.uk> <CA+55aFxfeXWAiXV18qGgOk9+2HHiD7LUuyk55brHFXd+_c6eZQ@mail.gmail.com> <20130131054002.GA3697@kroah.com> <CAKMK7uGUrvh2dXza_b288kVdztiLjSCNpH304oBQgg_ZonEnzw@mail.gmail.com> <20130131092146.GB3361@kroah.com> <CAPM=9tzZLPZ0EqEvEuZbimomSQv+xMnLpTq28z7=bKBF1w26TQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPM=9tzZLPZ0EqEvEuZbimomSQv+xMnLpTq28z7=bKBF1w26TQ@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 31, 2013 at 10:51:27PM +1100, Dave Airlie wrote:
> I'll ship them via my tree at this point I think, since I now need to
> queue a revert of the revert on top.
> 
> I have a few vgacon/fbcon fixes that I need to go in this cycle.

Great, thanks.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
