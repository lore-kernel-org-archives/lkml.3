Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752223AbaI3QeN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 12:34:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12194 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751146AbaI3QeM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 12:34:12 -0400
Date: Tue, 30 Sep 2014 18:33:53 +0200
From: Frantisek Hrbata <fhrbata@redhat.com>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        oleg@redhat.com, kamaleshb@in.ibm.com, hechjie@cn.ibm.com,
        akpm@linux-foundation.org, dvlasenk@redhat.com, prarit@redhat.com,
        lwoodman@redhat.com, hannsj_uhl@de.ibm.com,
        torvalds@linux-foundation.org
Subject: Re: [RESEND PATCH 2/4] x86: add phys addr validity check for
 /dev/mem mmap
Message-ID: <20140930163353.GC3073@localhost.localdomain>
Reply-To: Frantisek Hrbata <fhrbata@redhat.com>
References: <1411990382-11902-1-git-send-email-fhrbata@redhat.com>
 <1411990382-11902-3-git-send-email-fhrbata@redhat.com>
 <alpine.DEB.2.02.1409292211560.22082@ionos.tec.linutronix.de>
 <20140930124121.GB3073@localhost.localdomain>
 <542ABDE7.7090808@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <542ABDE7.7090808@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 30, 2014 at 07:27:51AM -0700, Dave Hansen wrote:
> On 09/30/2014 05:41 AM, Frantisek Hrbata wrote:
> > Does it make sense to replace "count" with "size" so it's consistent with the
> > rest or do you prefer "nr_bytes" or as Dave proposed "len_bytes"?
> 
> I don't care what it is as long as it has a unit in it.

Hi Dave/Thomas,

I sent v2 of this patch set, which uses the "len_bytes". Again, I'm sorry I
forgot to fix this the first time.

Many thanks

-- 
Frantisek Hrbata
