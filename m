Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755428AbaBGNQ1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 08:16:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18088 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755401AbaBGNQW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 08:16:22 -0500
Message-ID: <52F4DC9B.5050201@redhat.com>
Date: Fri, 07 Feb 2014 08:16:11 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Rashika Kheria <rashika.kheria@gmail.com>, linux-kernel@vger.kernel.org
CC: Andrew Morton <akpm@linux-foundation.org>,
        Michel Lespinasse <walken@google.com>, Hugh Dickins <hughd@google.com>,
        Oleg Nesterov <oleg@redhat.com>, linux-mm@kvack.org,
        josh@joshtriplett.org
Subject: Re: [PATCH 3/9] mm: Mark function as static in mmap.c
References: <a7658fc8f2ab015bffe83de1448cc3db79d2a9fc.1391167128.git.rashika.kheria@gmail.com> <a2b21fa8852f0ee5c8da179240142e5f084154e9.1391167128.git.rashika.kheria@gmail.com>
In-Reply-To: <a2b21fa8852f0ee5c8da179240142e5f084154e9.1391167128.git.rashika.kheria@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/2014 07:04 AM, Rashika Kheria wrote:
> Mark function as static in mmap.c because they are not used outside this
> file.
> 
> This eliminates the following warning in mm/mmap.c:
> mm/mmap.c:407:6: warning: no previous prototype for ‘validate_mm’ [-Wmissing-prototypes]
> 
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
