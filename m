Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966634Ab3HHVDL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 17:03:11 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:39989 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S966557Ab3HHVDJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 17:03:09 -0400
Message-ID: <1375995788.2087.8.camel@joe-AO722>
Subject: Re: [PATCH 2/2] Staging: BCM: Removed more whitespace/Errors
From: Joe Perches <joe@perches.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Paul McQuade <paulmcquad@gmail.com>, gregkh@linuxfoundation.org,
        Linux-Devel <devel@driverdev.osuosl.org>,
        Linux-kernel <linux-kernel@vger.kernel.org>
Date: Thu, 08 Aug 2013 14:03:08 -0700
In-Reply-To: <20130808204455.GC5502@mwanda>
References: <5203CF75.802@gmail.com> <20130808204455.GC5502@mwanda>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-08-08 at 23:44 +0300, Dan Carpenter wrote:
> On Thu, Aug 08, 2013 at 06:03:49PM +0100, Paul McQuade wrote:
> > -int InterfaceFileDownload( PVOID psIntfAdapter,
> > -                        struct file *flp,
> > -                        unsigned int on_chip_loc);
> > +int InterfaceFileDownload(PVOID psIntfAdapter,
> > +						struct file *flp,
> > +						unsigned int on_chip_loc);
> 
> 
> The very first line in this patch is totally wrong...  :(
> 
> This is an automated patch.

It is?

It doesn't look like an automated patch to me.
It looks like there are too many different style
choices for it to have been done by a machine.

Why do you think that?

Paul, how did you create this patch?

Dan, if you get a chance, could you try to use
checkpatch with the --fix option with specific
--types like SPACING and PARENTHESIS_ALIGNMENT
and tell me if you think it's OK?

