Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753423Ab3CKPoD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 11:44:03 -0400
Received: from mail-da0-f44.google.com ([209.85.210.44]:60069 "EHLO
	mail-da0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752794Ab3CKPoB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 11:44:01 -0400
Date: Mon, 11 Mar 2013 08:43:56 -0700
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <eag0628@gmail.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
        axboe@kernel.dk, jmoyer@redhat.com, zab@redhat.com
Subject: Re: [PATCHSET wq/for-3.10-tmp] workqueue: implement workqueue with
 custom worker attributes
Message-ID: <20130311154356.GL24522@htj.dyndns.org>
References: <1362194662-2344-1-git-send-email-tj@kernel.org>
 <513C61B9.5030004@cn.fujitsu.com>
 <20130310120113.GC24522@htj.dyndns.org>
 <CACvQF523Xeocr-wuu4iBG5ccG4j7K9tK1b687ddqgwszVi6f=A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACvQF523Xeocr-wuu4iBG5ccG4j7K9tK1b687ddqgwszVi6f=A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 11, 2013 at 11:42:29PM +0800, Lai Jiangshan wrote:
> >> for 1~13,15~22,26~28, please add Reviewed-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> 
> OK, Also add my Reviewed-by to 23~25.
> 
> >
> > Done.
> >
> 
> I didn't see you updated branch in your tree.

Working on something else and also waiting on the
s/PF_THREAD_BOUND/PF_NO_SETAFFINITY/ patch as the whole series has
been rebased on top.  I'll probably re-post in a few days.

Thanks!

-- 
tejun
