Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751959AbaABP6B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 10:58:01 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44605 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750882AbaABP5a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 10:57:30 -0500
Date: Thu, 2 Jan 2014 15:57:26 +0000
From: Mel Gorman <mgorman@suse.de>
To: SeongJae Park <sj38.park@gmail.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH] mm: page_alloc: use enum instead of number for
 migratetype
Message-ID: <20140102155726.GA865@suse.de>
References: <1388661922-10957-1-git-send-email-sj38.park@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1388661922-10957-1-git-send-email-sj38.park@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 02, 2014 at 08:25:22PM +0900, SeongJae Park wrote:
> Using enum instead of number for migratetype everywhere would be better
> for reading and understanding.
> 
> Signed-off-by: SeongJae Park <sj38.park@gmail.com>

This implicitly makes assumptions about the value of MIGRATE_UNMOVABLE
and does not appear to actually fix or improve anything.

-- 
Mel Gorman
SUSE Labs
