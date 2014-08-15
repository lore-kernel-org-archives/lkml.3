Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751716AbaHOTef (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 15:34:35 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:44009 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283AbaHOTed (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 15:34:33 -0400
Date: Fri, 15 Aug 2014 12:34:28 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] arch,locking: Ciao arch_mutex_cpu_relax()
Message-ID: <20140815193428.GA31566@roeck-us.net>
References: <1403288473.10903.2.camel@buesod1.americas.hpqcorp.net>
 <20140623065835.GF19860@laptop.programming.kicks-ass.net>
 <1403622415.15523.4.camel@buesod1.americas.hpqcorp.net>
 <20140625062510.GB4260@osiris>
 <1407460714.2513.19.camel@buesod1.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407460714.2513.19.camel@buesod1.americas.hpqcorp.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 07, 2014 at 06:18:34PM -0700, Davidlohr Bueso wrote:
> On Tue, 2014-08-05 at 10:42 -0700, Davidlohr Bueso wrote:
> > On Tue, 2014-08-05 at 15:04 +0200, Geert Uytterhoeven wrote:
> > > It looks like you forgot to update frv?  It's been failing on -next since a
> > > few days:
> 
> Anyway developers can be alerted sooner about this (ie: while its still
> in -next phase), like automated emails or something? This would be extra
> nice for those archs that are harder to get tested.
> 
> > > kernel/locking/mcs_spinlock.h:87:2: error: implicit declaration of
> > > function 'cpu_relax_lowlatency'
> > > [-Werror=implicit-function-declaration]
> > > cc1: some warnings being treated as errors
> > > kernel/locking/mcs_spinlock.h:87:2: error: implicit declaration of
> > > function 'cpu_relax_lowlatency'
> > > [-Werror=implicit-function-declaration]
> > > make[3]: *** [kernel/locking/mcs_spinlock.o] Error 1
> > > cc1: some warnings being treated as errors
> > > make[3]: *** [kernel/locking/mutex.o] Error 1
> > > 
> > > http://kisskb.ellerman.id.au/kisskb/buildresult/11616307/
> > 
> > Ah, indeed. Thanks for the report, afaict this was the only missing
> > arch .
> 
> Adding Guenter who also reported this yesterday.
> 
> Linus, since this is build-breaking an entire arch, it might be worth
> avoiding the whole -tip thing and get the fix in as soon as possible.
> 

Hi Davidlohr,

The fix is still not upstream, unfortunately. Maybe the patch got lost because
it was not sent as separate patch, or maybe it has to go through the frv
maintainer, or some Cc: was missing. Would be great if you could follow up
on this.

Thanks,
Guenter
