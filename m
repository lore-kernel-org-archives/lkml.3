Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933939Ab3LIQOX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 11:14:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7819 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932609Ab3LIQOV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 11:14:21 -0500
Message-ID: <52A5EC56.7080400@redhat.com>
Date: Mon, 09 Dec 2013 11:14:14 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Alex Thorlton <athorlton@sgi.com>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 13/18] mm: numa: Make NUMA-migrate related functions static
References: <1386572952-1191-1-git-send-email-mgorman@suse.de> <1386572952-1191-14-git-send-email-mgorman@suse.de>
In-Reply-To: <1386572952-1191-14-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/2013 02:09 AM, Mel Gorman wrote:
> numamigrate_update_ratelimit and numamigrate_isolate_page only have callers
> in mm/migrate.c. This patch makes them static.
> 
> Signed-off-by: Mel Gorman <mgorman@suse.de>

Reviewed-by: Rik van Riel <riel@redhat.com>


-- 
All rights reversed
