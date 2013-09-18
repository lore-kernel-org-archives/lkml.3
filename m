Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753342Ab3IRRGm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 13:06:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34018 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753302Ab3IRRGk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 13:06:40 -0400
Date: Wed, 18 Sep 2013 10:06:30 -0700
From: Zach Brown <zab@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Dave Kleikamp <dave.kleikamp@oracle.com>
Subject: Re: linux-next: manual merge of the vfs tree with the aio-direct tree
Message-ID: <20130918170630.GA2103@lenny.msi.event>
References: <20130918105638.6fa7c29605c14b408b7f5a7e@canb.auug.org.au>
 <20130918020035.GK13318@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130918020035.GK13318@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> As for aio-direct...  Two questions:
> 	* had anybody tried to measure the effect on branch predictor from
> introducing that method vector?  Commit d6afd4c4 ("iov_iter: hide iovec
> details behind ops function pointers")

FWIW, I never did.  I only went that route to begin with because the few
alternatives I tried before that were even more ugly :(.  It's been long
enough that I can't quite remember what I'd tried, though.

- z
