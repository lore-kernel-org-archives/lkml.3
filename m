Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934406Ab3CSWNO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 18:13:14 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:50997 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754682Ab3CSWNN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 18:13:13 -0400
Date: Tue, 19 Mar 2013 15:13:08 -0700
From: Tejun Heo <tj@kernel.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: linux-next: manual merge of the workqueues tree with Linus' tree
Message-ID: <20130319221308.GS3042@htj.dyndns.org>
References: <20130319131938.73dd0f1233c8aba41742aded@canb.auug.org.au>
 <20130319211233.GN3042@htj.dyndns.org>
 <20130320090540.81c687d28ffe3a6abe905816@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130320090540.81c687d28ffe3a6abe905816@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 20, 2013 at 09:05:40AM +1100, Stephen Rothwell wrote:
> > Anyways, I pulled master into wq/for-next and resolved it there, so it
> > shouldn't cause you any more trouble.
> 
> Ah, OK, thanks.   One small point, when you do a back merge like that,
> you should always put an explanation in the commit message for the merge.

Oh, I do that for any permanent branches.  for-next branches are
ephemeral (at least in my trees) so I usually don't bother.  I do
compare against for-next when and after sending pull requests with
proper conflict descriptions, so things are not likely to slip through
there.  Hmmm.... if it's gonna be helpful to you, I'd be happy to
describe merge conflicts and resolutions in for-next merges.  Would
that be helpful?

Thanks.

-- 
tejun
