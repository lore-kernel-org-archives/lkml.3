Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753649Ab3HPPEz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 11:04:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64462 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752952Ab3HPPEx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 11:04:53 -0400
Date: Fri, 16 Aug 2013 11:04:41 -0400
From: David Teigland <teigland@redhat.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: linux-next: manual merge of the dlm tree with Linus' tree
Message-ID: <20130816150441.GA20568@redhat.com>
References: <20130816114050.5f4bf4b21f1bde305235ac42@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130816114050.5f4bf4b21f1bde305235ac42@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 16, 2013 at 11:40:50AM +1000, Stephen Rothwell wrote:
> Hi David,
> 
> Today's linux-next merge of the dlm tree got a conflict in fs/dlm/user.c
> between commit 201d3dfa4da1 ("dlm: kill the unnecessary and wrong
> device_close()->recalc_sigpending()") from Linus' tree and commit
> c6ca7bc91d51 ("dlm: remove signal blocking") from the dlm tree.
> 
> I fixed it up (the latter is a superset of the former, so I just used it)
> and can carry the fix as necessary (no action is required).

Thanks, what's the procedure to get the right thing merged in the end?
Apply Oleg's patch to my tree followed by my own?

