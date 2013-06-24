Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751325Ab3FXWeJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 18:34:09 -0400
Received: from mail.skyhub.de ([78.46.96.112]:42520 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750990Ab3FXWeH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 18:34:07 -0400
Date: Tue, 25 Jun 2013 00:34:01 +0200
From: Borislav Petkov <bp@alien8.de>
To: George Spelvin <linux@horizon.com>
Cc: pablo@netfilter.org, gaofeng@cn.fujitsu.com, kaber@trash.net,
        linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        netfilter@vger.kernel.org
Subject: Re: v3.10-rc7 oops soon after boot
Message-ID: <20130624223401.GC24827@pd.tnic>
References: <20130624161305.GC26766@pd.tnic>
 <20130624221708.15489.qmail@science.horizon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130624221708.15489.qmail@science.horizon.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 24, 2013 at 06:17:08PM -0400, George Spelvin wrote:
> >> Reported-by: Borislav Petkov <bp@alien8.de>
> 
> > This should be:
> >
> > Reported-by: George Spelvin <linux@horizon.com>
> >
> > I only connected the dots...
> 
> Well, you did a whole lot more than me!  I just lobbed a "d'oh, it
> crashes" into the seething ocean of lkml.  (Admittedly, I had reason
> to act fast: we're very close to release.)
> 
> You figured out what subsystem was at fault and got the right people
> involved.  Definitely a valuable contribution.
> 
> Me, personally, I don't give a flying f*** about such credit; I had
> an itch and was trolling for someone to scratch it.
> 
> So feel free to take Reported-by (you are the one who reported it *to
> someone who could fix it*), Triaged-by, or whatever.

I was basically correcting how Reported-by is used - for the bug
reporter.

And yes, it is very important for us (even if you specifically don't
give a rat's rear end :-)) to credit the people - with their permission,
of course - who report bugs. Btw, I assume it is obvious why we need all
those good bug reports...

So I'm perfectly fine with you not giving flying f*ck about crediting as
long as you keep testing -rcs and reporting issues.

:-)

Thanks!

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
