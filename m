Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752087AbaFFR5A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 13:57:00 -0400
Received: from casper.infradead.org ([85.118.1.10]:58516 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717AbaFFR47 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 13:56:59 -0400
Date: Fri, 6 Jun 2014 19:56:55 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Pranith Kumar <pranith@gatech.edu>
Cc: linux-kernel@vger.kernel.org, tim.c.chen@linux.intel.com, davidlohr@hp.com,
        mingo@redhat.com
Subject: Re: [RFC PATCH 1/1] cleanup: use bool as return type for
 rwsem_is_locked
Message-ID: <20140606175655.GX13930@laptop.programming.kicks-ass.net>
References: <5390D7E1.7060606@gatech.edu>
 <5391FFFD.1060901@gatech.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <5391FFFD.1060901@gatech.edu>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 06, 2014 at 01:53:01PM -0400, Pranith Kumar wrote:
> On Fri, Jun 6, 2014 at 3:35 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> >
> > Now in general, I don't particularly like such superfluous changes, so
> > unless you can show that GCC actually generates better code, I'd prefer
> > to keep things as they are.
> 
> Fixed and checked the assembly. It saves us 2 bytes of code, not much. I am not sure if that is worth it :(

still 2 bytes, so sure.

Which gcc did you use and what arch did you build? That might be useful
info for the changelog.
