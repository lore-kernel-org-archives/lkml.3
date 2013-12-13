Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752336Ab3LMNDg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 08:03:36 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39198 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751801Ab3LMNDf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 08:03:35 -0500
Date: Fri, 13 Dec 2013 14:03:31 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Emanuel Krenz <emanuelkrenz@web.de>
cc: Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HID: hid-multitouch: add support for SiS panel in LG
 23ET83V
In-Reply-To: <52AAE22A.30701@web.de>
Message-ID: <alpine.LNX.2.00.1312131401550.12702@pobox.suse.cz>
References: <52AA2810.2010807@web.de> <20131213020542.GE13333@kroah.com> <alpine.LRH.2.00.1312131036520.7125@twin.jikos.cz> <52AAE22A.30701@web.de>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Dec 2013, Emanuel Krenz wrote:

> > Emanuel, what is going on here, please? Is it that you authored this patch
> > yourself, and would like to have it included in Linus' tree (only then it
> > can go to -stable)?
> > 
> > If so, please remove all Signoffs of people who haven't provided it to
> > you, and resubmit it to maintainer (./scripts/get_maintainer.pl will tell
> > you who are proper recepients of this patch).
> > 
> > Thanks,
> > 
> Hello,
> I'm sorry, guys. I thought I have to add those "Signed-off-by" lines to
> mention, where I got the ideas for this patch from.

For real meaning of Signed-off-by:, please refer to 
Documentation/SubmittingPatches, section 12.

> It was actually this patch: https://lkml.org/lkml/2013/12/2/647 That was 
> obviously a mistake, please forgive me. As I mentioned, this was my 
> first submitted patch, I was just so excited that I might help 
> developing.
> 
> Thank you, Jiri, for telling me, to remove this "Signed-off-by" lines and
> resubmit the patch after using get_maintainer.pl.
> Now I actually got your name as the maintainer of HID CORE LAYER. So i'll send
> it to you again without those lines, i hope it's correct now.

Yup, that is the proper process.

Thanks for submitting the patch, I'll respond to that separately.

-- 
Jiri Kosina
SUSE Labs
