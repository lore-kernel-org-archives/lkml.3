Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753307AbaFGV45 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2014 17:56:57 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:34014 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753146AbaFGV44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2014 17:56:56 -0400
Date: Sat, 7 Jun 2014 14:56:54 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Fabian Frederick <fabf@skynet.be>
cc: linux-kernel@vger.kernel.org, Christoph Lameter <cl@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/1] mm/slab.c: add __init to init_lock_keys
In-Reply-To: <1402140626-20914-1-git-send-email-fabf@skynet.be>
Message-ID: <alpine.DEB.2.02.1406071454070.24927@chino.kir.corp.google.com>
References: <1402140626-20914-1-git-send-email-fabf@skynet.be>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 7 Jun 2014, Fabian Frederick wrote:

> init_lock_keys is only called by __init kmem_cache_init_late
> 
> Cc: Christoph Lameter <cl@linux-foundation.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Fabian Frederick <fabf@skynet.be>

No functional change because these functions are inlined, but it makes 
sense anyway.

Acked-by: David Rientjes <rientjes@google.com>
