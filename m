Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751823AbaEWShI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 14:37:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51803 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750971AbaEWShG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 14:37:06 -0400
Message-ID: <537F9534.7020603@redhat.com>
Date: Fri, 23 May 2014 14:36:36 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Davidlohr Bueso <davidlohr@hp.com>, akpm@linux-foundation.org
CC: mingo@kernel.org, peterz@infradead.org, mgorman@suse.de, aswin@hp.com,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] mm: rename leftover i_mmap_mutex
References: <1400816006-3083-1-git-send-email-davidlohr@hp.com> <1400816006-3083-6-git-send-email-davidlohr@hp.com>
In-Reply-To: <1400816006-3083-6-git-send-email-davidlohr@hp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/22/2014 11:33 PM, Davidlohr Bueso wrote:
> Update the lock to i_mmap_rwsem throughout the kernel.
> All changes are in comments and documentation.
> 
> Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>

Acked-by: Rik van Riel <riel@redhat.com>


-- 
All rights reversed
