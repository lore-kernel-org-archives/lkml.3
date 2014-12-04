Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752734AbaLDBx6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 20:53:58 -0500
Received: from mail-qg0-f48.google.com ([209.85.192.48]:38198 "EHLO
	mail-qg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752569AbaLDBx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 20:53:56 -0500
MIME-Version: 1.0
In-Reply-To: <1417657437.2902.27.camel@perches.com>
References: <1417655529-8640-1-git-send-email-arun267@gmail.com>
	<20141204012517.GA31563@kroah.com>
	<CAJ8d=beEFz-wKaN4bodZFN9BCrUsZKy=F0e-R7fUVXsf+04g4A@mail.gmail.com>
	<20141204013925.GA32401@kroah.com>
	<1417657437.2902.27.camel@perches.com>
Date: Wed, 3 Dec 2014 17:53:56 -0800
Message-ID: <CAJ8d=bc0ZeZ3gwLQnUfbjBV1+Hb0=pWpbnpGT+M6HaNOPGA57Q@mail.gmail.com>
Subject: Re: [PATCH] Staging: bcm: Fix lines exceeding 80 character limit in
 CmHost.h This is a patch to CmHost.h that fixes Exceeds 80 Character limits
 warning found by checkpatch.pl Signed-off-by: Arun Ayyer <arun267@gmail.com>
From: arun vijayshankar <arun267@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Greg and Joe!

I will work against -next

Regards,
Arun.

On Wed, Dec 3, 2014 at 5:43 PM, Joe Perches <joe@perches.com> wrote:
>
> On Wed, 2014-12-03 at 17:39 -0800, Greg KH wrote:
> > On Wed, Dec 03, 2014 at 05:31:59PM -0800, arun vijayshankar wrote:
> > > Hi Greg,
> >
> > If you turn off HTML email, your message will not get rejected by the
> > mailing lists :)
> >
> > > I completely agree! I thought of keeping the patch summary as the subject, but
> > > I wasn't sure and ending up entering nothing. Git then used this by default.
> >
> > You forgot a blank line after your first line in the git commit message,
> > which caused it to get all merged together.
> >
> > Try fixing that up and resending please.
>
> No need.  This directory has been deleted.
>
> Please work against -next (or Greg's staging tree)
>
>



-- 
Arun.
