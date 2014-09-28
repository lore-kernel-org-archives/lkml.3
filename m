Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753898AbaI1VJL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2014 17:09:11 -0400
Received: from mail-qg0-f48.google.com ([209.85.192.48]:48559 "EHLO
	mail-qg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750947AbaI1VJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2014 17:09:09 -0400
Date: Sun, 28 Sep 2014 17:09:06 -0400
From: Tejun Heo <tj@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH driver-core-next] kernfs: fix fill_super failure path
Message-ID: <20140928210906.GA8349@mtj.dyndns.org>
References: <20140928171254.GA29787@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140928171254.GA29787@mtj.dyndns.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 28, 2014 at 01:12:54PM -0400, Tejun Heo wrote:
> After kernfs_fill_super() failure, the half-initialized sb still goes
> through kernfs_kill_sb() for destruction; unfortunately,
> kernfs_kill_sb() dereferences sb->s_root which may be NULL after
> fill_super failure triggering the following oops when such error
> condition is artificially injected.

Please ignore this patch.  This isn't enough.

Thanks.

-- 
tejun
