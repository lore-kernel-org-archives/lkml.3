Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752846AbaFPXH7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 19:07:59 -0400
Received: from mail-ig0-f170.google.com ([209.85.213.170]:45747 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752610AbaFPXH6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 19:07:58 -0400
Date: Mon, 16 Jun 2014 16:07:56 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Michal Nazarewicz <mina86@mina86.com>
cc: Christoph Lameter <clameter@sgi.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: page_alloc: simplify drain_zone_pages by using
 min()
In-Reply-To: <1402952894-13200-1-git-send-email-mina86@mina86.com>
Message-ID: <alpine.DEB.2.02.1406161607430.21018@chino.kir.corp.google.com>
References: <1402952894-13200-1-git-send-email-mina86@mina86.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Jun 2014, Michal Nazarewicz wrote:

> Instead of open-coding getting minimal value of two, just use min macro.
> That is why it is there for.  While changing the function also change
> type of batch local variable to match type of per_cpu_pages::batch
> (which is int).
> 
> Signed-off-by: Michal Nazarewicz <mina86@mina86.com>

Acked-by: David Rientjes <rientjes@google.com>
