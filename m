Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757369AbaDHPSc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 11:18:32 -0400
Received: from asavdk4.altibox.net ([109.247.116.15]:37380 "EHLO
	asavdk4.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756788AbaDHPSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 11:18:30 -0400
Date: Tue, 8 Apr 2014 17:18:25 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Michal Marek <mmarek@suse.cz>
Cc: Masahiro Yamada <yamada.m@jp.panasonic.com>, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] Kbuild: move extra gcc check flags to the top Makefile
Message-ID: <20140408151824.GA31595@ravnborg.org>
References: <1396840939-24512-1-git-send-email-yamada.m@jp.panasonic.com>
 <53441091.2060706@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53441091.2060706@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 08, 2014 at 05:06:57PM +0200, Michal Marek wrote:
> On 2014-04-07 05:22, Masahiro Yamada wrote:
> > If W=... given to the command line, extra gcc check flags are added
> > to KBUILD_CFLAGS.
> > 
> > If we have such code in scripts/Makefile.build, the same flags are
> > added to KBUILD_CFLAGS multiple times becuase scripts/Makefile.build
> > is invoked every time Kbuild descends into the subdirectories.
> 
> Indeed. For three years, nobody has noticed that the gcc commandline is
> growing with every subdirectory.
I once had a patchset that moved all this out - to avoid this.
It was lost for various reasons.

The top-level Makefile is already too cluttered - so adding all this
is not good.
Moving it all to a dedicated file would be better.

	Sam
