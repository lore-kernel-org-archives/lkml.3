Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751472Ab3BGGVB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 01:21:01 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58144 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821Ab3BGGU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 01:20:59 -0500
Date: Wed, 6 Feb 2013 22:23:57 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        Sasha Levin <sasha.levin@oracle.com>
Subject: Re: linux-next: manual merge of the akpm-current tree with the kvm
 tree
Message-Id: <20130206222357.02d049e6.akpm@linux-foundation.org>
In-Reply-To: <20130207170319.5b5c471398b134c676f9dc6c@canb.auug.org.au>
References: <20130207170319.5b5c471398b134c676f9dc6c@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Feb 2013 17:03:19 +1100 Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Andrew,
> 
> Today's linux-next merge of the akpm-current tree got a conflict in
> arch/x86/kvm/mmu.c between commit 9bb4f6b15ec0 ("KVM: MMU: drop unneeded
> checks") from the kvm tree and commit "hlist: drop the node parameter
> from iterators" from the akpm-current tree.
> 
> I fixed it up (the conflicts were caused by bad white space changes in
> the akpm tree patch) and can carry the fix as necessary (no action is
> required).

hm, not sure what you meant by "bad" but that patch went and took the
nice fits-in-80-cols kvm code and mucked it all up.  Shall unmuck
tomorrow.

