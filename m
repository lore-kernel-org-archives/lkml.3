Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934169Ab3LIQ5w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 11:57:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42504 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933953Ab3LIQ5v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 11:57:51 -0500
Message-ID: <52A5F687.9010003@redhat.com>
Date: Mon, 09 Dec 2013 11:57:43 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Alex Thorlton <athorlton@sgi.com>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 16/18] mm: numa: Do not automatically migrate KSM pages
References: <1386572952-1191-1-git-send-email-mgorman@suse.de> <1386572952-1191-17-git-send-email-mgorman@suse.de>
In-Reply-To: <1386572952-1191-17-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/2013 02:09 AM, Mel Gorman wrote:
> KSM pages can be shared between tasks that are not necessarily related
> to each other from a NUMA perspective. This patch causes those pages to
> be ignored by automatic NUMA balancing so they do not migrate and do not
> cause unrelated tasks to be grouped together.
> 
> Signed-off-by: Mel Gorman <mgorman@suse.de>

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
