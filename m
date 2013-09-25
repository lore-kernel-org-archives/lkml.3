Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752276Ab3IYR1I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 13:27:08 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47372 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855Ab3IYR1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 13:27:07 -0400
Date: Wed, 25 Sep 2013 10:27:04 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Benjamin Valentin <benpicco@zedat.fu-berlin.de>
Cc: STAGING SUBSYSTEM <devel@driverdev.osuosl.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] add exFAT driver
Message-ID: <20130925172704.GB5258@kroah.com>
References: <20130830124622.5f81b7d4@rechenknecht2k7>
 <20130830154205.GA1411@kroah.com>
 <20130925183632.08a0d073@rechenknecht2k7>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130925183632.08a0d073@rechenknecht2k7>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 25, 2013 at 06:36:32PM +0200, Benjamin Valentin wrote:
> Am Fri, 30 Aug 2013 08:42:05 -0700
> schrieb Greg Kroah-Hartman <gregkh@linuxfoundation.org>:
>  
> > For staging drivers I need a maintainer that is going to take the time
> > to shephard it into the core kernel tree.  See other TODO files for
> > how that person is defined.  Are you going to be willing to do this?
> 
> I can see what I can do.

Great.

> I've cleaned up the code a bit, especially where it would redefine
> kernel functions. [1] Should I submit the end result, one file per
> patch, or begin with the original code and submit patches on top of
> that?

Probably start with the original submission from Samsung, with their
signed-off-by: lines, and then add patches afterward that from you with
your fixes / cleanups.  That shows the development effort and gives
everyone the proper credit/blame :)

> Also, the driver would define it's own data types like
>     typedef unsigned int            UINT32;
> 
> I've replaced that with u32, etc as the naming implied the bit size
> would matter. (And it probably does for the on-disk file system
> structures, but they are used for everything) Is there any disadvantage
> to this over using the standard C types?

Those _are_ the standard kernel C types, so that's the correct thing to
do.

> > Also, I would really like to get a signed-off-by: from the Samsung
> > authors for this patch, can you do that as well please?
> 
> I've tried reaching them by their last public e-mail addresses I could
> find, but they would either bounce or I got no reply.

Who did you contact at Samsung?  I'll be visiting there in a week so I
can try to track some people done in person.  I really want their
signed-off-by: on the patch, as it is their code to start with, and it's
a bit rude to not get their approval for the code to be merged.

thanks,

greg k-h
