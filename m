Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752445AbaLYXe2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2014 18:34:28 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:58677 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816AbaLYXeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2014 18:34:24 -0500
Date: Thu, 25 Dec 2014 18:34:20 -0500 (EST)
Message-Id: <20141225.183420.2288499637535959481.davem@davemloft.net>
To: kirill.shutemov@linux.intel.com
Cc: akpm@linux-foundation.org, peterz@infradead.org, mingo@kernel.org,
        davej@redhat.com, sasha.levin@oracle.com, hughd@google.com,
        linux-mm@kvack.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 33/38] sparc: drop pte_file()-related helpers
From: David Miller <davem@davemloft.net>
In-Reply-To: <1419423766-114457-34-git-send-email-kirill.shutemov@linux.intel.com>
References: <1419423766-114457-1-git-send-email-kirill.shutemov@linux.intel.com>
	<1419423766-114457-34-git-send-email-kirill.shutemov@linux.intel.com>
X-Mailer: Mew version 6.6 on Emacs 24.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 25 Dec 2014 15:34:23 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Date: Wed, 24 Dec 2014 14:22:41 +0200

> We've replaced remap_file_pages(2) implementation with emulation.
> Nobody creates non-linear mapping anymore.
> 
> This patch also increase number of bits availble for swap offset.
> 
> Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> Cc: "David S. Miller" <davem@davemloft.net>

Acked-by: David S. Miller <davem@davemloft.net>
