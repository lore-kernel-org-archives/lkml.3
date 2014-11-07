Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752670AbaKGUwd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 15:52:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56645 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751766AbaKGUwc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 15:52:32 -0500
Date: Fri, 07 Nov 2014 15:52:14 -0500 (EST)
Message-Id: <20141107.155214.85049633626458011.davem@redhat.com>
To: andreas@gaisler.com
Cc: sparclinux@vger.kernel.org, sam@ravnborg.org, linux-kernel@vger.kernel.org,
        software@gaisler.com
Subject: Re: [PATCH] sparc32: Implement xchg and atomic_xchg using
 ATOMIC_HASH locks
From: David Miller <davem@redhat.com>
In-Reply-To: <1415199128-22339-1-git-send-email-andreas@gaisler.com>
References: <1415199128-22339-1-git-send-email-andreas@gaisler.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Larsson <andreas@gaisler.com>
Date: Wed,  5 Nov 2014 15:52:08 +0100

> Atomicity between xchg and cmpxchg cannot be guaranteed when xchg is
> implemented with a swap and cmpxchg is implemented with locks.
> Without this, e.g. mcs_spin_lock and mcs_spin_unlock are broken.
> 
> Signed-off-by: Andreas Larsson <andreas@gaisler.com>

Unfortunate, but obviously necessary.

Applied and queued up for -stable, thanks!
