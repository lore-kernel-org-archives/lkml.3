Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753508AbaKJQ2c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 11:28:32 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44862 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752152AbaKJQ2b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 11:28:31 -0500
Date: Mon, 10 Nov 2014 16:28:27 +0000
From: Mel Gorman <mgorman@suse.de>
To: Davidlohr Bueso <dave@stgolabs.net>
Cc: akpm@linux-foundation.org, hughd@google.com, riel@redhat.com,
        peterz@infradead.org, mingo@kernel.org, linux-kernel@vger.kernel.org,
        dbueso@suse.de, linux-mm@kvack.org
Subject: Re: [PATCH v2 -next 00/10] mm: improve usage of the i_mmap lock
Message-ID: <20141110162827.GA21422@suse.de>
References: <1414697657-1678-1-git-send-email-dave@stgolabs.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1414697657-1678-1-git-send-email-dave@stgolabs.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2014 at 12:34:07PM -0700, Davidlohr Bueso wrote:
> Changes from v1:
>  o Collected Acks from Kirill and Srikar.
>  o Updated to apply on top of linux-next.
> 

FWIW, I looked at all the patches when looking at the hugetlbfs sharing
part and while it was not a very detailed review, I also did not see
anything bad so for patches 1-7, 9 and 11

Acked-by: Mel Gorman <mgorman@suse.de>

-- 
Mel Gorman
SUSE Labs
