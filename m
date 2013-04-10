Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937087Ab3DJXuy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 19:50:54 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:49788 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761186Ab3DJXux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 19:50:53 -0400
Date: Wed, 10 Apr 2013 16:50:51 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH] mm: madvise: complete input validation before taking
 lock
In-Reply-To: <u0leheij6gt.fsf@orc05.imf.au.dk>
Message-ID: <alpine.DEB.2.02.1304101650210.27541@chino.kir.corp.google.com>
References: <u0leheij6gt.fsf@orc05.imf.au.dk>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Apr 2013, Rasmus Villemoes wrote:

> In madvise(), there doesn't seem to be any reason for taking the
> &current->mm->mmap_sem before start and len_in have been
> validated. Incidentally, this removes the need for the out: label.
> 
> 
> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>

Acked-by: David Rientjes <rientjes@google.com>

Would be nice to do s/out_plug/out/ now if you have a chance.
