Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752327AbaGQBte (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 21:49:34 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:59709 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751139AbaGQBtb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 21:49:31 -0400
Date: Wed, 16 Jul 2014 18:49:28 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Lennox Wu <lennox.wu@gmail.com>, Liqin Chen <liqin.linux@gmail.com>
cc: Chen Gang <gang.chen.5i5j@gmail.com>, Guenter Roeck <linux@roeck-us.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] arch/score/include/uapi/asm/ptrace.h: Remove the
 macros which not be used currently
In-Reply-To: <alpine.DEB.2.02.1406261456150.12443@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.02.1407161849090.19429@chino.kir.corp.google.com>
References: <53AC10CB.3000007@gmail.com> <alpine.DEB.2.02.1406261456150.12443@chino.kir.corp.google.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jun 2014, David Rientjes wrote:

> On Thu, 26 Jun 2014, Chen Gang wrote:
> 
> > 'COUNTER' and other same kind macros are too common to use, and easy to
> > get conflict with other modules.
> > 
> > At present, they are not used, so it is OK to simply remove them. And the
> > related warning (allmodconfig with score):
> > 
> >     CC [M]  drivers/md/raid1.o
> >   In file included from drivers/md/raid1.c:42:0:
> >   drivers/md/bitmap.h:93:0: warning: "COUNTER" redefined
> >    #define COUNTER(x) (((bitmap_counter_t) x) & COUNTER_MAX)
> >    ^
> >   In file included from ./arch/score/include/asm/ptrace.h:4:0,
> >                    from include/linux/sched.h:31,
> >                    from include/linux/blkdev.h:4,
> >                    from drivers/md/raid1.c:36:
> >   ./arch/score/include/uapi/asm/ptrace.h:13:0: note: this is the location of the previous definition
> >    #define COUNTER  38
> > 
> > 
> > Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
> 
> Acked-by: David Rientjes <rientjes@google.com>
> 

Lennox or Liqin, could you please queue this patch for 3.17?
