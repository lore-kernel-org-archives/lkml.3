Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932682Ab3GPNQQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 09:16:16 -0400
Received: from kanga.kvack.org ([205.233.56.17]:52015 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932356Ab3GPNQP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 09:16:15 -0400
Date: Tue, 16 Jul 2013 09:16:14 -0400
From: Benjamin LaHaise <bcrl@kvack.org>
To: Gu Zheng <guz.fnst@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Al Viro <viro@zeniv.linux.org.uk>, tangchen <tangchen@cn.fujitsu.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Subject: Re: [PATCH RESEND 1/2] fs/anon_inode: Introduce a new lib function anon_inode_getfile_private()
Message-ID: <20130716131614.GC5403@kvack.org>
References: <51E518BC.8040900@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51E518BC.8040900@cn.fujitsu.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 16, 2013 at 05:56:12PM +0800, Gu Zheng wrote:
> 
> Introduce a new lib function anon_inode_getfile_private(), it creates a new file
> instance by hooking it up to an anonymous inode, and a dentry that describe the
> "class" of the file, similar to anon_inode_getfile(), but each file holds a
> single inode. Furthermore, anyone who wants to create a private anon file will
> benefit from this change.
> 
> Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
> Signed-off-by: Benjamin LaHaise <bcrl@kvack.org>

Please don't add my Signed-off-by when I have never even seen or reviewed 
a patch -- that is completely unacceptable.  Second, I don't think this 
patch is suitable for 3.11, as it has not seen much testing outside of one 
test program I had written.  It's a long standing bug, so it isn't urgent 
to get the fix into the tree.  That said, it did pass a few tests I ran 
last night, so it is probably suitable for the -next tree.

As for patch 1, it looks okay to me, but will need Al Viro's signoff.

		-ben
-- 
"Thought is the essence of where you are now."
