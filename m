Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755162AbaI3V5x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 17:57:53 -0400
Received: from www.linutronix.de ([62.245.132.108]:33719 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754422AbaI3V5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 17:57:51 -0400
Date: Tue, 30 Sep 2014 23:57:46 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Frantisek Hrbata <fhrbata@redhat.com>
cc: Dave Hansen <dave.hansen@intel.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        oleg@redhat.com, kamaleshb@in.ibm.com, hechjie@cn.ibm.com,
        akpm@linux-foundation.org, dvlasenk@redhat.com, prarit@redhat.com,
        lwoodman@redhat.com, hannsj_uhl@de.ibm.com,
        torvalds@linux-foundation.org
Subject: Re: [RESEND PATCH 2/4] x86: add phys addr validity check for /dev/mem
 mmap
In-Reply-To: <20140930163353.GC3073@localhost.localdomain>
Message-ID: <alpine.DEB.2.11.1409302357290.4455@nanos>
References: <1411990382-11902-1-git-send-email-fhrbata@redhat.com> <1411990382-11902-3-git-send-email-fhrbata@redhat.com> <alpine.DEB.2.02.1409292211560.22082@ionos.tec.linutronix.de> <20140930124121.GB3073@localhost.localdomain> <542ABDE7.7090808@intel.com>
 <20140930163353.GC3073@localhost.localdomain>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Sep 2014, Frantisek Hrbata wrote:
> On Tue, Sep 30, 2014 at 07:27:51AM -0700, Dave Hansen wrote:
> > On 09/30/2014 05:41 AM, Frantisek Hrbata wrote:
> > > Does it make sense to replace "count" with "size" so it's consistent with the
> > > rest or do you prefer "nr_bytes" or as Dave proposed "len_bytes"?
> > 
> > I don't care what it is as long as it has a unit in it.
> 
> Hi Dave/Thomas,
> 
> I sent v2 of this patch set, which uses the "len_bytes". Again, I'm sorry I
> forgot to fix this the first time.

No problem. Shit happens.
