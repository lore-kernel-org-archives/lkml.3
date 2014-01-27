Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754193AbaA0WM7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 17:12:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1464 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753876AbaA0WM6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 17:12:58 -0500
Message-ID: <52E6D9D8.2060205@redhat.com>
Date: Mon, 27 Jan 2014 17:12:40 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>, Andrew Morton <akpm@linux-foundation.org>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: numa: Initialse numa balancing after jump label initialisation
References: <20140127155127.GJ4963@suse.de>
In-Reply-To: <20140127155127.GJ4963@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/27/2014 10:51 AM, Mel Gorman wrote:
> The command line parsing takes place before jump labels are initialised which
> generates a warning if numa_balancing= is specified and CONFIG_JUMP_LABEL
> is set. On older kernls before commit c4b2c0c5 (static_key: WARN on
> usage before jump_label_init was called) the kernel would have crashed.
> This patch enables automatic numa balancing later in the initialisation
> process if numa_balancing= is specified.
> 
> Signed-off-by: Mel Gorman <mgorman@suse.de>
> Cc: Stable <stable@vger.kernel.org>

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
