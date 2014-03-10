Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091AbaCJPvQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 11:51:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19990 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753760AbaCJPvN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 11:51:13 -0400
Date: Mon, 10 Mar 2014 11:50:53 -0400
From: Dave Jones <davej@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>
Subject: Re: deadlock in lru_add_drain ? (3.14rc5)
Message-ID: <20140310155053.GA26188@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, Tejun Heo <tj@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Chris Metcalf <cmetcalf@tilera.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-mm <linux-mm@kvack.org>
References: <20140308220024.GA814@redhat.com>
 <CA+55aFzLxY8Xsn90v1OAsmVBWYPZTiJ74YE=HaCPYR2hvRfk+g@mail.gmail.com>
 <20140310150106.GD25290@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140310150106.GD25290@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 10, 2014 at 11:01:06AM -0400, Tejun Heo wrote:

 > > On Sat, Mar 8, 2014 at 2:00 PM, Dave Jones <davej@redhat.com> wrote:
 > > > I left my fuzzing box running for the weekend, and checked in on it this evening,
 > > > to find that none of the child processes were making any progress.
 > > > cat'ing /proc/n/stack shows them all stuck in the same place..
 > > > Some examples:
 > 
 > Dave, any chance you can post full sysrq-t dump?

It's too big to fit in the ring-buffer, so some of it gets lost before
it hits syslog, but hopefully what made it to disk is enough.
http://codemonkey.org.uk/junk/sysrq-t

	Dave

