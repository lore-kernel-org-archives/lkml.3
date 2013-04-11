Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760313Ab3DKWeT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 18:34:19 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39571 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759089Ab3DKWeD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 18:34:03 -0400
Date: Thu, 11 Apr 2013 15:34:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Paul Clements <paul.clements@steeleye.com>
Cc: <linux-kernel@vger.kernel.org>, <belczyk@bsd.krakow.pl>
Subject: Re: [PATCH] nbd: increase default and max request sizes
Message-Id: <20130411153402.12cfa2ad0c4501be1331e748@linux-foundation.org>
In-Reply-To: <20130402194120.54043222C0@clements>
References: <20130402194120.54043222C0@clements>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  2 Apr 2013 15:41:20 -0400 (EDT) Paul Clements <paul.clements@steeleye.com> wrote:

> This patch raises the default max request size for nbd to 128KB (from 127KB)
> to get it 4KB aligned. This patch also allows the max request size to be
> increased (via /sys/block/nbd<x>/queue/max_sectors_kb) to 32MB.
> 
> The patch makes nbd network traffic more efficient by:
> - reducing request fragmentation (4KB alignment)
> - reducing the number of requests (fewer round trips, less network overhead)
> 
> Especially in high latency networks, larger request size can make a dramatic
> difference in performance.
> 
> From: Michal Belczyk <belczyk@bsd.krakow.pl>
> Signed-off-by: Paul Clements <paul.clements@steeleye.com>

This is a bit odd.

- The author's "From:" line shouild appear right at the start of the
  changelog.

- Michal's Signed-off-by: is absent.  Is one available?

Thanks.
