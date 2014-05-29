Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753732AbaE2XKL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 19:10:11 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:59619 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752875AbaE2XKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 19:10:09 -0400
Date: Fri, 30 May 2014 08:10:04 +0900
From: Simon Horman <horms@verge.net.au>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        devel <devel@driverdev.osuosl.org>,
        SH-Linux <linux-sh@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH v2 04/05] staging: board: Initial board staging support
Message-ID: <20140529231001.GC2353@verge.net.au>
References: <20140529131650.2329.3197.sendpatchset@w520>
 <20140529131732.2329.50630.sendpatchset@w520>
 <20140529132034.GB15585@mwanda>
 <CANqRtoTzOn5d9qB85sXvmLYhoTDMDtbjSkLbz9V4FRmzFM3ycQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANqRtoTzOn5d9qB85sXvmLYhoTDMDtbjSkLbz9V4FRmzFM3ycQ@mail.gmail.com>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2014 at 10:27:30PM +0900, Magnus Damm wrote:
> Hi Dan,
> 
> On Thu, May 29, 2014 at 10:20 PM, Dan Carpenter
> <dan.carpenter@oracle.com> wrote:
> > On Thu, May 29, 2014 at 10:17:32PM +0900, Magnus Damm wrote:
> >> --- /dev/null
> >> +++ work/drivers/staging/board/Kconfig        2014-05-29 21:40:41.000000000 +0900
> >> @@ -0,0 +1,7 @@
> >> +config STAGING_BOARD
> >> +     boolean "Staging Board Support"
> >> +     help
> >> +       Select to enable per-board staging support code.
> >> +
> >> +       If in doubt, say N here.
> >> +
> >
> > Actually, you're probably going to need to add a bunch of dependencies
> > here or it will break "make randconfig" right away.  Sorry that I forgot
> > about this in the first review.
> 
> Good point, thanks for checking. I will have a look at this and add
> dependencies to make sure it builds on a wide range of platforms.

Hi Magnus,

let me know if you would like me to perform some build-testing.

> Regarding the emxx_udc portion of the patches (in the v2 series patch
> 1 -> 3), if there are no objections would it be possible for you to
> take them as-is? If so I'll resend the staging board bits only.
> 
> Thanks!
> 
> / magnus
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sh" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
