Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751267Ab3IYQgi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 12:36:38 -0400
Received: from outpost1.zedat.fu-berlin.de ([130.133.4.66]:47844 "EHLO
	outpost1.zedat.fu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750855Ab3IYQgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 12:36:36 -0400
Date: Wed, 25 Sep 2013 18:36:32 +0200
From: Benjamin Valentin <benpicco@zedat.fu-berlin.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org,
        STAGING SUBSYSTEM <devel@driverdev.osuosl.org>
Subject: Re: [PATCH] add exFAT driver
Message-ID: <20130925183632.08a0d073@rechenknecht2k7>
In-Reply-To: <20130830154205.GA1411@kroah.com>
References: <20130830124622.5f81b7d4@rechenknecht2k7>
	<20130830154205.GA1411@kroah.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.17; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Originating-IP: 77.186.48.189
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Fri, 30 Aug 2013 08:42:05 -0700
schrieb Greg Kroah-Hartman <gregkh@linuxfoundation.org>:
 
> For staging drivers I need a maintainer that is going to take the time
> to shephard it into the core kernel tree.  See other TODO files for
> how that person is defined.  Are you going to be willing to do this?

I can see what I can do.

I've cleaned up the code a bit, especially where it would redefine
kernel functions. [1] Should I submit the end result, one file per
patch, or begin with the original code and submit patches on top of
that?

Also, the driver would define it's own data types like
    typedef unsigned int            UINT32;

I've replaced that with u32, etc as the naming implied the bit size
would matter. (And it probably does for the on-disk file system
structures, but they are used for everything) Is there any disadvantage
to this over using the standard C types?

> Also, I would really like to get a signed-off-by: from the Samsung
> authors for this patch, can you do that as well please?

I've tried reaching them by their last public e-mail addresses I could
find, but they would either bounce or I got no reply.

[1] https://github.com/benpicco/linux_exfat-staging/commits/exfat
