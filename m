Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512AbaBYTPV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 14:15:21 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:43938 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753177AbaBYTPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 14:15:17 -0500
Date: Tue, 25 Feb 2014 14:07:16 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the wireless-next tree
Message-ID: <20140225190715.GA4384@tuxdriver.com>
References: <20140225133537.55ce6935e55faa6aeae53d89@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140225133537.55ce6935e55faa6aeae53d89@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 25, 2014 at 01:35:37PM +1100, Stephen Rothwell wrote:
> Hi John,
> 
> After merging the wireless-next tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
> 
> drivers/staging/rtl8821ae/rc.c:289:2: error: unknown field 'module' specified in initializer
>   .module = NULL,
>   ^
> 
> Caused by commit 161d78555435 ("Revert "Staging: rtl8812ae: remove
> modules field of rate_control_ops"").
> 
> The commit "Staging: rtl8812ae: remove modules field of rate_control_ops"
> was needed in the wireless-next tree - I said so at the time of reporting
> the original breakage: 
> 
> > Actually, your tree is based on -rc2, so you need this patch already (it
> > should have bee included in the merge commit 841577c3d33b ("Merge branch
> > 'for-john' of
> > git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next").
> 
> And now that part of the wireless-next tree has migrated to the net-next tree.
> 
> I have no idea why you thought you should revert the fix.
> 
> I have used the wireless tree from next-20140224 for today.

The fix should go through Greg's tree.  I shouldn't have merged it at all.

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
