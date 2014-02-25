Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753556AbaBYUh4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 15:37:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9011 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752724AbaBYUhz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 15:37:55 -0500
Message-ID: <530CFF1B.8020901@redhat.com>
Date: Tue, 25 Feb 2014 15:37:47 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>
CC: Jan Stancek <jstancek@redhat.com>, Mel Gorman <mgorman@suse.de>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/2] mm: fix GFP_THISNODE callers and clarify
References: <1393360022-22566-1-git-send-email-hannes@cmpxchg.org> <1393360022-22566-2-git-send-email-hannes@cmpxchg.org>
In-Reply-To: <1393360022-22566-2-git-send-email-hannes@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/25/2014 03:27 PM, Johannes Weiner wrote:
> GFP_THISNODE is for callers that implement their own clever fallback
> to remote nodes, and so no direct reclaim is invoked.  There are many
> current users that only want node exclusiveness but still want reclaim
> to make the allocation happen.  Convert them over to __GFP_THISNODE
> and update the documentation to clarify GFP_THISNODE semantics.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: Rik van Riel <riel@redhat.com>


-- 
All rights reversed
