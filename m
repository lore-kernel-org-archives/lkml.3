Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752403AbaBGUsC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 15:48:02 -0500
Received: from mail-pb0-f49.google.com ([209.85.160.49]:42172 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751546AbaBGUsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 15:48:00 -0500
Date: Fri, 7 Feb 2014 12:47:58 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Rashika Kheria <rashika.kheria@gmail.com>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Michel Lespinasse <walken@google.com>,
        Hugh Dickins <hughd@google.com>, Oleg Nesterov <oleg@redhat.com>,
        linux-mm@kvack.org, josh@joshtriplett.org
Subject: Re: [PATCH 3/9] mm: Mark function as static in mmap.c
In-Reply-To: <a2b21fa8852f0ee5c8da179240142e5f084154e9.1391167128.git.rashika.kheria@gmail.com>
Message-ID: <alpine.DEB.2.02.1402071247470.4212@chino.kir.corp.google.com>
References: <a7658fc8f2ab015bffe83de1448cc3db79d2a9fc.1391167128.git.rashika.kheria@gmail.com> <a2b21fa8852f0ee5c8da179240142e5f084154e9.1391167128.git.rashika.kheria@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="531381512-2106216631-1391806079=:4212"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--531381512-2106216631-1391806079=:4212
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Fri, 7 Feb 2014, Rashika Kheria wrote:

> Mark function as static in mmap.c because they are not used outside this
> file.
> 
> This eliminates the following warning in mm/mmap.c:
> mm/mmap.c:407:6: warning: no previous prototype for ‘validate_mm’ [-Wmissing-prototypes]
> 
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>

Acked-by: David Rientjes <rientjes@google.com>
--531381512-2106216631-1391806079=:4212--
