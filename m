Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752485Ab3LMJjl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 04:39:41 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34738 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752305Ab3LMJji (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 04:39:38 -0500
Date: Fri, 13 Dec 2013 10:39:34 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Greg KH <gregkh@linuxfoundation.org>, Emanuel Krenz <emanuelkrenz@web.de>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HID: hid-multitouch: add support for SiS panel in LG
 23ET83V
In-Reply-To: <20131213020542.GE13333@kroah.com>
Message-ID: <alpine.LRH.2.00.1312131036520.7125@twin.jikos.cz>
References: <52AA2810.2010807@web.de> <20131213020542.GE13333@kroah.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Dec 2013, Greg KH wrote:

> > 3.12.5-stable patch
> > 
> > --------------------
> > From: Emanuel Krenz <emanuelkrenz@web.de>
> > 
> > Add support for SiS multitouch panel in the touch monitor LG 23ET83V.
> > 
> > Signed-off-by: Emanuel Krenz <emanuelkrenz@web.de>
> > Signed-off-by: Forest Bond <forest.bond@rapidrollout.com>
> > Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> I signed off on this?  What is the git commit id of the patch in Linus's
> tree?

I haven't either, and I don't think I have ever seen this patch (it's 
definitely neither in Linus' nor my tree).

Emanuel, what is going on here, please? Is it that you authored this patch 
yourself, and would like to have it included in Linus' tree (only then it 
can go to -stable)?

If so, please remove all Signoffs of people who haven't provided it to 
you, and resubmit it to maintainer (./scripts/get_maintainer.pl will tell 
you who are proper recepients of this patch).

Thanks,

-- 
Jiri Kosina
SUSE Labs

