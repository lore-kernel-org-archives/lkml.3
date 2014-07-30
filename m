Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754570AbaG3BU2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 21:20:28 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:49728 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926AbaG3BU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 21:20:27 -0400
Date: Tue, 29 Jul 2014 18:20:16 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Alexey Dobriyan <adobriyan@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] headers: remove fs.h from poll.h
In-Reply-To: <20140705090745.GA13990@p183.telecom.by>
Message-ID: <alpine.DEB.2.02.1407291818380.6967@chino.kir.corp.google.com>
References: <20140701200150.GA31103@p183.telecom.by> <20140701134338.1d221dd127ffef4c25e86800@linux-foundation.org> <20140701220642.GA3150@p183.telecom.by> <alpine.DEB.2.02.1407021605490.5931@chino.kir.corp.google.com>
 <20140705090745.GA13990@p183.telecom.by>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 5 Jul 2014, Alexey Dobriyan wrote:

> On Wed, Jul 02, 2014 at 04:09:17PM -0700, David Rientjes wrote:
> > Lots of #ifdefs in fs.h, I hope your series includes building for all 
> > possible combinations.
> 
> If google can donate 1 million of cpu hours to me, then yeah :-)
> 
> > > This is first patch in series. Same thing we did with sched.h earlier.
> > > 
> > 
> > Is it possible to post the whole series together so it makes sense and 
> > it's possible to put it through some thorough build testing?  If you can 
> > point me to a git tree that I can pull, then I can do that on 
> > infrastructure that I have probably quicker than most.
> 
> Sure, attached.
> 
> My compile test farm is kinda rotten right now, so any help is appreciated.
> 
> Compile tested on x86_64 and lightly on arm.
> 

Ok, this series applies to linux-next-20140728 with a couple of errors:

error: drivers/staging/frontier/alphatrack.c: No such file or directory
error: drivers/staging/frontier/tranzport.c: No such file or directory
error: drivers/usb/gadget/f_hid.c: No such file or directory

so I removed those hunks from 0009-headers-fs.h-vs-input.h.patch and will 
do build testing on them.
