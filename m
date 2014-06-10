Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753951AbaFJW4V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 18:56:21 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:60200 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752756AbaFJW4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 18:56:20 -0400
Date: Tue, 10 Jun 2014 15:56:18 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Fabian Frederick <fabf@skynet.be>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [PATCH 1/1] mm/readahead.c: remove unused file_ra_state from
 count_history_pages
In-Reply-To: <1402424846-9652-1-git-send-email-fabf@skynet.be>
Message-ID: <alpine.DEB.2.02.1406101556080.32203@chino.kir.corp.google.com>
References: <1402424846-9652-1-git-send-email-fabf@skynet.be>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jun 2014, Fabian Frederick wrote:

> count_history_pages does only call page_cache_prev_hole in rcu_lock
> context using address_space mapping. There's no need to have file_ra_state
> here.
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Fengguang Wu <fengguang.wu@intel.com>
> Signed-off-by: Fabian Frederick <fabf@skynet.be>

Acked-by: David Rientjes <rientjes@google.com>
