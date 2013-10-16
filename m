Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760859Ab3JPP4L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 11:56:11 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:29497 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753057Ab3JPP4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 11:56:10 -0400
Message-ID: <1381938967.4324.0.camel@buesod1.americas.hpqcorp.net>
Subject: Re: still running into WARNING: CPU: at fs/ext4/inode.c:230
 ext4_evict_inode+0x4a6/0x4e0
From: Davidlohr Bueso <davidlohr@hp.com>
To: Jan Kara <jack@suse.cz>
Cc: tytso@mit.edu, Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-ext4@vger.kernel.org
Date: Wed, 16 Oct 2013 08:56:07 -0700
In-Reply-To: <20131016125004.GC14278@quack.suse.cz>
References: <1381888924.2371.5.camel@buesod1.americas.hpqcorp.net>
	 <20131016125004.GC14278@quack.suse.cz>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-10-16 at 14:50 +0200, Jan Kara wrote:
> On Tue 15-10-13 19:02:04, Davidlohr Bueso wrote:
> > Hello Jan,
> > 
> > Just wanted to let you know I hit this[1] again on Linus' latest. The
> > setup/workload is *identical* to the reported one a few months ago.
> > 
> > [1] https://lkml.org/lkml/2013/8/1/532
> > 
> > Here's the complete output, I hope it helps...
>   Thanks for the headup. Last time I wasn't able to reproduce this and
> eventually forgot about the problem. Can I send you a debug patch and you
> would run a kernel with it? Thanks.

Sure.

