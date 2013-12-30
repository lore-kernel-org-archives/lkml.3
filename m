Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756022Ab3L3O50 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 09:57:26 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:43557 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755870Ab3L3O5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 09:57:24 -0500
Date: Mon, 30 Dec 2013 07:57:21 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Li Wang <liwang@ubuntukylin.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Cong Wang <xiyou.wangcong@gmail.com>, Zefan Li <lizefan@huawei.com>
Subject: Re: [PATCH 0/3] Fadvise: Directory level page cache cleaning
	support
Message-ID: <20131230145720.GB20793@parisc-linux.org>
References: <cover.1388409686.git.liwang@ubuntukylin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1388409686.git.liwang@ubuntukylin.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 30, 2013 at 09:45:15PM +0800, Li Wang wrote:
> VFS relies on LRU-like page cache eviction algorithm

Why is this a series of three patches?  It just seems like you're trying
to game the patch count statistics.  One patch would have been fine for
this tiny change.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
