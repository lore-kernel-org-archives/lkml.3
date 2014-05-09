Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756219AbaEII2X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 04:28:23 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:28056 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752325AbaEII2V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 04:28:21 -0400
Date: Fri, 9 May 2014 11:28:03 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: DaeSeok Youn <daeseok.youn@gmail.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, devel <devel@driverdev.osuosl.org>,
        nandini h <nandu.hgowda@gmail.com>,
        "sachin.kamat" <sachin.kamat@linaro.org>,
        peter.p.waskiewicz.jr@intel.com,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Himangi Saraogi <himangi774@gmail.com>,
        Chekameh Cobbler <fempsci@gmail.com>
Subject: Re: [PATCH 1/3] staging: cxt1e1: Fix no spaces at the start of a
 line in musycc.c
Message-ID: <20140509082803.GC4963@mwanda>
References: <20140509013843.GA30927@devel.8.8.4.4>
 <20140509075904.GJ26890@mwanda>
 <CAHb8M2AOxLS_nA4BFy2q7+TyyLYxUTmzVULn8dvuR-X2fsET=w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHb8M2AOxLS_nA4BFy2q7+TyyLYxUTmzVULn8dvuR-X2fsET=w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 09, 2014 at 05:22:18PM +0900, DaeSeok Youn wrote:
> 2014-05-09 16:59 GMT+09:00 Dan Carpenter <dan.carpenter@oracle.com>:
> > On Fri, May 09, 2014 at 10:38:43AM +0900, Daeseok Youn wrote:
> >> clean up checkpatch.pl warning:
> >>  WARNING: please no spaces at the start of a line in
> >>
> >> Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
> >> ---
> >> This patch includes cleanup for fixing line length.
> >>
> >
> > This patch is super hard to review.  Your "line length" fixes include
> > moving variable declarations around, deleting comments, getting rid of
> > nonsense curly braces.  Those are all great but the patch is over a
> > thousand lines long and it's difficult to review.
> Yes.. I knew that. And sorry about that. but I was really hard to
> separate this patch for
> fixing coding style. :-(
> When I replaced spaces with tabs, it has too many tabs so I cannot leave
>  that lines on this patch.(and removed curly braces can solve my concern..)
> But I should do as your comment.

Yeah.  I know that it means we go over the 80 character limit.  Don't
stress about that.

regards,
dan carpenter

