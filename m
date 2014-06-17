Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967784AbaFQWwG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 18:52:06 -0400
Received: from mail-qc0-f173.google.com ([209.85.216.173]:45597 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965497AbaFQWwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 18:52:03 -0400
Date: Tue, 17 Jun 2014 18:51:59 -0400
From: Tejun Heo <tj@kernel.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: the cgroup tree has an unnecessary merge
Message-ID: <20140617225159.GA8838@mtj.dyndns.org>
References: <20140618084921.07c3b391@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140618084921.07c3b391@canb.auug.org.au>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Stephen.

On Wed, Jun 18, 2014 at 08:49:21AM +1000, Stephen Rothwell wrote:
> The cgroup tree has a merge of 963649d735c8 and c731ae1d0f02 both of
> which are already merged into v3.16-rc1.  Why did you just not use
> v3.16-rc1 itself (or the point where Linus merged your tree) (and then
> add the other commit on top?  That would have removed any chance that
> you resolved the merged differently to how it was resolved in Linus'
> tree (I don't know if there is a difference, but I have had conflicts
> from different merge resolutions in the past).

Oops, my mistake.  Reset to for-3.16-fixes.

Thanks.

-- 
tejun
