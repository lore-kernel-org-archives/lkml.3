Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752384Ab3JINzL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 09:55:11 -0400
Received: from kanga.kvack.org ([205.233.56.17]:55290 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751692Ab3JINzJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 09:55:09 -0400
Date: Wed, 9 Oct 2013 09:55:09 -0400
From: Benjamin LaHaise <bcrl@kvack.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@osdl.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-aio@kvack.org
Subject: Re: [rfc] rework aio migrate pages to use aio fs
Message-ID: <20131009135509.GB16003@kvack.org>
References: <20130913165937.GL2517@kvack.org> <20130913184204.GS13318@ZenIV.linux.org.uk> <20130917141825.GF11526@kvack.org> <20131003022251.GB13318@ZenIV.linux.org.uk> <20131003025007.GC13318@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131003025007.GC13318@ZenIV.linux.org.uk>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Al,

On Thu, Oct 03, 2013 at 03:50:07AM +0100, Al Viro wrote:
...
> Another thing: I'd rather pull everything about setting the inode
> up (aops, size, etc.) in there.
> 
> Anyway, could you take a look at the last couple of commits in
> vfs.git#for-bcrl?  Commit message on the last one is an atrocity,
> of course...

Sorry for not replying sooner, I'd actually reviewed this last week but got 
distracted before replying.

This looks much better in terms of the code that is specific to aio.  I've 
run the aio tests I wrote for the numa page migration test case, and they 
look okay with your changes from vfs.git@for-bcrl.  Please feel free to 
add my Tested/Acked-by.

Tested-by: Benjamin LaHaise <bcrl@kvack.org>
Acked-by: Benjamin LaHaise <bcrl@kvack.org>

		-ben
-- 
"Thought is the essence of where you are now."
