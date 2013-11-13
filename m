Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757836Ab3KMCJn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 21:09:43 -0500
Received: from merlin.infradead.org ([205.233.59.134]:47387 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755778Ab3KMCJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 21:09:34 -0500
Date: Tue, 12 Nov 2013 19:09:18 -0700
From: Jens Axboe <axboe@kernel.dk>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: tj@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-arm-kernel@lists.infradead.org,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 04/24] mm/block: remove unnecessary inclusion of bootmem.h
Message-ID: <20131113020918.GA25143@kernel.dk>
References: <1383954120-24368-1-git-send-email-santosh.shilimkar@ti.com>
 <1383954120-24368-5-git-send-email-santosh.shilimkar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383954120-24368-5-git-send-email-santosh.shilimkar@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 08 2013, Santosh Shilimkar wrote:
> From: Grygorii Strashko <grygorii.strashko@ti.com>
> 
> Clean-up to remove depedency with bootmem headers.

Thanks, cleaned up for after merge window inclusion. Changed the wording
to make it more correct and fixed the spelling error:

block: cleanup removing dependency on bootmem headers

-- 
Jens Axboe

