Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754040Ab3H0T3n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 15:29:43 -0400
Received: from cobra.newdream.net ([66.33.216.30]:53333 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753298Ab3H0T3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 15:29:41 -0400
Date: Tue, 27 Aug 2013 12:29:40 -0700 (PDT)
From: Sage Weil <sage@inktank.com>
X-X-Sender: sage@cobra.newdream.net
To: Randy Dunlap <rdunlap@infradead.org>
cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, ceph-devel@vger.kernel.org
Subject: Re: linux-next: Tree for Aug 27 (ceph)
In-Reply-To: <521CF7D6.5090807@infradead.org>
Message-ID: <alpine.DEB.2.00.1308271229230.24783@cobra.newdream.net>
References: <20130827203008.1c54283d628ef706f51a866a@canb.auug.org.au> <521CF7D6.5090807@infradead.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Aug 2013, Randy Dunlap wrote:
> On 08/27/13 03:30, Stephen Rothwell wrote:
> > Hi all,
> > 
> > I should know better than to take time off around -rc7 :-)
> > 
> > Changes since 20130822:
> > 
> 
> on i386:
> 
> fs/built-in.o: In function `ceph_fallocate':
> file.c:(.text+0x20b171): undefined reference to `__divdi3'

I've fixed this up in the ceph tree.

Thanks!
sage
 
