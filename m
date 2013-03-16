Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756050Ab3CPWPK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Mar 2013 18:15:10 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:58121 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751733Ab3CPWPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Mar 2013 18:15:04 -0400
Date: Sat, 16 Mar 2013 15:16:11 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Martin Walch <walch.martin@web.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: RAMster selects HAVE_ALIGNED_STRUCT_PAGE on 64 bit systems when
 it should not
Message-ID: <20130316221611.GC3702@kroah.com>
References: <1577953.rJTZvHtihu@tacticalops>
 <1363466844.1335.133.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363466844.1335.133.camel@x61.thuisdomein>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 16, 2013 at 09:47:24PM +0100, Paul Bolle wrote:
> On Sat, 2013-03-16 at 20:35 +0100, Martin Walch wrote:
> > 64_BIT should probably say 64BIT which has corresponding config sections in 
> > arch/{x86,ia64,mips,s390,tile,alpha,arm64,sparc,parisc,powerpc}/Kconfig and 
> > arch/x86/um/Kconfig.
> > 
> > I do not know if there are any bad consequences about this, but I guess this 
> > should be reviewed and fixed, probably by just removing the underscore from 
> > 64_BIT in drivers/staging/zcache/Kconfig.
> 
> It's an obvious typo. See the patch I sent last week:
> https://lkml.org/lkml/2013/3/9/106 . I have not yet received any
> feedback.

Your patch is in my "to-apply" queue that I should get to soon.  It's
only 137 patches back at the moment...

thanks,

greg "my queue is bigger than yours" k-h
