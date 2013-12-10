Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754241Ab3LJQ4T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 11:56:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9461 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751791Ab3LJQ4Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 11:56:16 -0500
Message-ID: <52A747A8.9030307@redhat.com>
Date: Tue, 10 Dec 2013 11:56:08 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Alex Thorlton <athorlton@sgi.com>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 12/18] mm: numa: Defer TLB flush for THP migration as
 long as possible
References: <1386690695-27380-1-git-send-email-mgorman@suse.de> <1386690695-27380-13-git-send-email-mgorman@suse.de>
In-Reply-To: <1386690695-27380-13-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/2013 10:51 AM, Mel Gorman wrote:
> THP migration can fail for a variety of reasons. Avoid flushing the TLB
> to deal with THP migration races until the copy is ready to start.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Mel Gorman <mgorman@suse.de>

Reviewed-by: Rik van Riel <riel@redhat.com>


-- 
All rights reversed
