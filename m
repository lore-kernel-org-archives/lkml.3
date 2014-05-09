Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756718AbaEIOPr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 10:15:47 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:17260 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754166AbaEIOPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 10:15:46 -0400
Date: Fri, 9 May 2014 17:15:34 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: DaeSeok Youn <daeseok.youn@gmail.com>
Cc: gregkh@linuxfoundation.org, himangi774@gmail.com, sachin.kamat@linaro.org,
        fempsci@gmail.com, nandu.hgowda@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] staging: cxt1e1: remove dead code in musycc.c
Message-ID: <20140509141534.GK4963@mwanda>
References: <20140509100606.GA6479@devel.8.8.4.4>
 <20140509105149.GH4963@mwanda>
 <CAHb8M2AopFJGhgZOu_hbn2YWvMgeuFz2zK2uYo4Fnt6kACKSOg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHb8M2AopFJGhgZOu_hbn2YWvMgeuFz2zK2uYo4Fnt6kACKSOg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 09, 2014 at 11:09:35PM +0900, DaeSeok Youn wrote:
> 2014-05-09 19:51 GMT+09:00, Dan Carpenter <dan.carpenter@oracle.com>:
> > On Fri, May 09, 2014 at 07:06:06PM +0900, Daeseok Youn wrote:
> >> Removes "#if 0" blocks.
> >>
> >> Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
> >> ---
> >> Dan,
> >>  I decided to leave musycc_dump_rxbuffer_ring(ch, 0) which is commented
> >>  out and make a block as "RLD_DEBUG". Because i think this block need to
> >> debug
> >>  with define "RLD_DEBUG". If I am wrong, let me know.
> >>
> >
> > This change should maybe have been in a separate patch.  It's a border
> > line thing.  But definitely, it should have been mentioned in the
> > changelog.
> >
> > Btw, you can use `git citool` to add or remove lines from a
> > commit.  Highlight and right click on the lines you want to add or
> > remove.
> Thanks for the tip. I used "git add -p" after "git rebase" and "git
> reset HEAD" for
> spliting a patch.
> But I have a question, Do I have to resend rest of patches after
> spliting this patch?
> In this case, 2/5 is splited to two, it doesn't need to rebase but
> numbering of patches are changed.

Probably it's simplest to just fixup the changelog and resend as-is.
If you split a patch then normally it's easiest to just resend
everything.

If you have to resend just one patch and it doesn't affect the later
patches then you can just resend that one so long as you get the
In-Reply-To email header correct.  If you don't know what an In-Reply-To
header is, then resend everything.

regards,
dan carpenter

