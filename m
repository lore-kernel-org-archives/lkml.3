Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753564AbaEWRRI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 13:17:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15195 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753447AbaEWRRH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 13:17:07 -0400
Message-ID: <537F8276.60902@redhat.com>
Date: Fri, 23 May 2014 13:16:38 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Davidlohr Bueso <davidlohr@hp.com>, akpm@linux-foundation.org
CC: mingo@kernel.org, peterz@infradead.org, mgorman@suse.de, aswin@hp.com,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] mm: use new helper functions around the i_mmap_mutex
References: <1400816006-3083-1-git-send-email-davidlohr@hp.com> <1400816006-3083-3-git-send-email-davidlohr@hp.com>
In-Reply-To: <1400816006-3083-3-git-send-email-davidlohr@hp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/22/2014 11:33 PM, Davidlohr Bueso wrote:
> Convert all open coded mutex_lock/unlock calls to the
> i_mmap_[lock/unlock]_write() helpers.
> 
> Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>

Acked-by: Rik van Riel <riel@redhat.com>


-- 
All rights reversed
