Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755876Ab3AUOd5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 09:33:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2194 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753485Ab3AUOd4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 09:33:56 -0500
Message-ID: <50FD51C4.6070909@redhat.com>
Date: Mon, 21 Jan 2013 09:33:40 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH] mm/rmap: rename anon_vma_unlock() => anon_vma_unlock_write()
References: <20130121115921.23500.7190.stgit@zurg>
In-Reply-To: <20130121115921.23500.7190.stgit@zurg>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21/2013 06:59 AM, Konstantin Khlebnikov wrote:
> comment in 4fc3f1d66b1ef0d7b8dc11f4ff1cc510f78b37d6 ("mm/rmap, migration:
> Make rmap_walk_anon() and try_to_unmap_anon() more scalable") says:
>
> | Rename anon_vma_[un]lock() => anon_vma_[un]lock_write(),
> | to make it clearer that it's an exclusive write-lock in
> | that case - suggested by Rik van Riel.
>
> But that commit renames only anon_vma_lock()
>
> Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Rik van Riel <riel@redhat.com>

Reviewed-by: Rik van Riel <riel@redhat.com>


-- 
All rights reversed
