Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965874Ab3HHPg1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 11:36:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14463 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965787Ab3HHPg0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 11:36:26 -0400
Date: Thu, 8 Aug 2013 11:36:15 -0400
From: Dave Jones <davej@redhat.com>
To: Hillf Danton <dhillf@gmail.com>
Cc: linux-mm@kvack.org, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: unused swap offset / bad page map.
Message-ID: <20130808153615.GA6197@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Hillf Danton <dhillf@gmail.com>, linux-mm@kvack.org,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20130807055157.GA32278@redhat.com>
 <CAJd=RBCJv7=Qj6dPW2Ha=nq6JctnK3r7wYCAZTm=REVOZUNowg@mail.gmail.com>
 <20130807153030.GA25515@redhat.com>
 <CAJd=RBCyZU8PR7mbFUdKsWq3OH+5HccEWKMEH5u7GNHNy3esWg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJd=RBCyZU8PR7mbFUdKsWq3OH+5HccEWKMEH5u7GNHNy3esWg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 08, 2013 at 11:20:28PM +0800, Hillf Danton wrote:
 > On Wed, Aug 7, 2013 at 11:30 PM, Dave Jones <davej@redhat.com> wrote:
 > > printk didn't trigger.
 > >
 > Is a corrupted page table entry encountered, according to the
 > comment of swap_duplicate()?
 > 
 > 
 > --- a/mm/swapfile.c	Wed Aug  7 17:27:22 2013
 > +++ b/mm/swapfile.c	Thu Aug  8 23:12:30 2013
 > @@ -770,6 +770,7 @@ int free_swap_and_cache(swp_entry_t entr
 >  		unlock_page(page);
 >  		page_cache_release(page);
 >  	}
 > +	return 1;
 >  	return p != NULL;
 >  }

Travelling for a week, I'll check it out when I get back.

	Dave

