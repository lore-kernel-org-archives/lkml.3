Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753603AbaFWLTS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 07:19:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43747 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753202AbaFWLTR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 07:19:17 -0400
Date: Mon, 23 Jun 2014 12:19:14 +0100
From: Mel Gorman <mgorman@suse.de>
To: Chen Yucong <slaoub@gmail.com>
Cc: hannes@cmpxchg.org, mhocko@suse.cz, riel@redhat.com,
        akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm:kswapd: clean up the kswapd
Message-ID: <20140623111914.GK10819@suse.de>
References: <1403500494-5110-1-git-send-email-slaoub@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1403500494-5110-1-git-send-email-slaoub@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2014 at 01:14:54PM +0800, Chen Yucong wrote:
> According to the commit 215ddd66 (mm: vmscan: only read new_classzone_idx from
> pgdat when reclaiming successfully) and the commit d2ebd0f6b (kswapd: avoid
> unnecessary rebalance after an unsuccessful balancing), we can use a boolean
> variable for replace balanced_* variables, which makes the kswapd more clarify.
> 
> Signed-off-by: Chen Yucong <slaoub@gmail.com>

I think this is just churning code for the sake of it. It's not any
easier to understand as a result of the modification and does not appear
to be a preparation for a follow-on patch that addresses a bug.

-- 
Mel Gorman
SUSE Labs
