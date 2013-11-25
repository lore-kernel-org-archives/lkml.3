Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752483Ab3KYWIQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 17:08:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29525 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750709Ab3KYWIN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 17:08:13 -0500
Message-ID: <5293CA44.10904@redhat.com>
Date: Mon, 25 Nov 2013 17:08:04 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Vlastimil Babka <vbabka@suse.cz>, linux-mm@kvack.org
CC: linux-kernel@vger.kernel.org, Mel Gorman <mgorman@suse.de>
Subject: Re: [PATCH 1/5] mm: compaction: encapsulate defer reset logic
References: <1385389570-11393-1-git-send-email-vbabka@suse.cz> <1385389570-11393-2-git-send-email-vbabka@suse.cz>
In-Reply-To: <1385389570-11393-2-git-send-email-vbabka@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/25/2013 09:26 AM, Vlastimil Babka wrote:
> Currently there are several functions to manipulate the deferred compaction
> state variables. The remaining case where the variables are touched directly
> is when a successful allocation occurs in direct compaction, or is expected
> to be successful in the future by kswapd. Here, the lowest order that is
> expected to fail is updated, and in the case of direct compaction, the deferred
> status is reset completely.
>
> Create a new function compaction_defer_reset() to encapsulate this
> functionality and make it easier to understand the code. No functional change.
>
> Cc: Mel Gorman <mgorman@suse.de>
> Cc: Rik van Riel <riel@redhat.com>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>

Reviewed-by: Rik van Riel <riel@redhat.com>

