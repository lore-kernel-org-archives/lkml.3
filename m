Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934064Ab3LIQr0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 11:47:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17475 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934008Ab3LIQrX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 11:47:23 -0500
Message-ID: <52A5F40F.40206@redhat.com>
Date: Mon, 09 Dec 2013 11:47:11 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Alex Thorlton <athorlton@sgi.com>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 14/18] mm: numa: Limit scope of lock for NUMA migrate
 rate limiting
References: <1386572952-1191-1-git-send-email-mgorman@suse.de> <1386572952-1191-15-git-send-email-mgorman@suse.de>
In-Reply-To: <1386572952-1191-15-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/2013 02:09 AM, Mel Gorman wrote:
> NUMA migrate rate limiting protects a migration counter and window using
> a lock but in some cases this can be a contended lock. It is not
> critical that the number of pages be perfect, lost updates are
> acceptable. Reduce the importance of this lock.
> 
> Signed-off-by: Mel Gorman <mgorman@suse.de>

Reviewed-by: Rik van Riel <riel@redhat.com>


-- 
All rights reversed
