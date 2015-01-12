Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551AbbALPGi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 10:06:38 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:55833 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204AbbALPGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 10:06:37 -0500
Date: Mon, 12 Jan 2015 16:06:33 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com
Subject: Re: [RFC 1/4] lockdep: additional lock specific information when
 dumping locks
Message-ID: <20150112150633.GD25256@twins.programming.kicks-ass.net>
References: <1421074631-18831-1-git-send-email-sasha.levin@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421074631-18831-1-git-send-email-sasha.levin@oracle.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2015 at 09:57:08AM -0500, Sasha Levin wrote:
> When dumping held locks, it might be useful to get additional lock-specific
> information about each lock.
> 
> This is mainly useful to figure out who really holds each lock rather then
> who's just waiting on it, but it could be extended further or extended to
> the other lockdep users if required.

I really don't see the point in this; I would much rather have something
useful like:

 http://lwn.net/Articles/579849/
