Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752711AbaBLAiJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 19:38:09 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:41298 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869AbaBLAiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 19:38:07 -0500
Date: Wed, 12 Feb 2014 00:38:03 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Fengguang Wu <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [process_vm_access] BUG: unable to handle kernel paging request
 at fffffff27b92dd20
Message-ID: <20140212003803.GL18016@ZenIV.linux.org.uk>
References: <20140210112231.GA11951@localhost>
 <20140211162745.c4fdb96ec58fa9581e6c2841@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140211162745.c4fdb96ec58fa9581e6c2841@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 11, 2014 at 04:27:45PM -0800, Andrew Morton wrote:
> On Mon, 10 Feb 2014 19:22:31 +0800 Fengguang Wu <fengguang.wu@intel.com> wrote:
> 
> > We noticed the below oops since commit 68a25f08c9bec07ad95e55a01b127168e43aed84
> > ("process_vm_access: take get_user_pages/put_pages one level up")
> > while running ltp tests inside kvm.
> 
> I can't find this patch anywhere.  Where did it come from?

It used to be in vfs.git#iov_iter; fixed since then, but this stuff is still
not in #for-next.
