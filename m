Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934547AbaFSVJW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 17:09:22 -0400
Received: from mail-qc0-f179.google.com ([209.85.216.179]:55361 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934385AbaFSVJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 17:09:21 -0400
Date: Thu, 19 Jun 2014 17:09:17 -0400
From: Tejun Heo <tj@kernel.org>
To: Christoph Lameter <cl@gentwo.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET percpu/for-3.17] percpu: clean up percpu accessor and
 operation definitions
Message-ID: <20140619210917.GC9814@mtj.dyndns.org>
References: <1402590209-31610-1-git-send-email-tj@kernel.org>
 <20140617232202.GD8838@mtj.dyndns.org>
 <alpine.DEB.2.11.1406191603570.5484@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1406191603570.5484@gentwo.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 19, 2014 at 04:05:29PM -0500, Christoph Lameter wrote:
> On Tue, 17 Jun 2014, Tejun Heo wrote:
> 
> > >   linus master c31c24b8251f ("Merge branch 'next' of git://git.kernel.org/pub/scm/linux/kernel/git/rzhang/linux")
> > > + [1] [PATCH RFC] percpu: add data dependency barrier in percpu accessors and operations
> >
> > Omitted the data dependency barrier and applied the series to
> > percpu/for-3.17.
> 
> Ok I hope all of that dependency material is removed from the tree?

Hmmm?  There was one RFC patch which I didn't apply.  I'm leaning
towards just clearly documenting the init write ownership because that
seems more consistent but seriously no matter which way we go there's
*no* performance implication.  I don't get why you're so fixated about
it.

-- 
tejun
