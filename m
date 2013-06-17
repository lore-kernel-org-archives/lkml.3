Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751864Ab3FQQNp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 12:13:45 -0400
Received: from cobra.newdream.net ([66.33.216.30]:55573 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751062Ab3FQQNn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 12:13:43 -0400
Date: Mon, 17 Jun 2013 09:13:43 -0700 (PDT)
From: Sage Weil <sage@inktank.com>
X-X-Sender: sage@cobra.newdream.net
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: Sage Weil <sage@newdream.net>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build warning after merge of the ceph tree
In-Reply-To: <20130617182934.8aab7e40dc01c91702b564b1@canb.auug.org.au>
Message-ID: <alpine.DEB.2.00.1306170913270.31579@cobra.newdream.net>
References: <20130617182934.8aab7e40dc01c91702b564b1@canb.auug.org.au>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

<facepalm>, fixed.  Thanks!

sage

On Mon, 17 Jun 2013, Stephen Rothwell wrote:

> Hi Sage,
> 
> After merging the ceph tree, today's linux-next build (x86_64
> allmodconfig) produced this warning:
> 
> drivers/block/rbd.c: In function 'rbd_release':
> drivers/block/rbd.c:510:2: warning: 'return' with a value, in function returning void [enabled by default]
>   return 0;
>   ^
> 
> Caused by commit f28d6bf9ef4d ("Merge remote-tracking branch
> 'linus/master' into testing").
> 
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 
