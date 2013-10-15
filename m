Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759696Ab3JOTkK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 15:40:10 -0400
Received: from merlin.infradead.org ([205.233.59.134]:37219 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759303Ab3JOTkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 15:40:08 -0400
Date: Tue, 15 Oct 2013 13:40:00 -0600
From: Jens Axboe <axboe@kernel.dk>
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Cc: jg1.han@samsung.com, akpm@linux-foundation.org,
        yongjun_wei@trendmicro.com.cn, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mg_disk: remove deprecated IRQF_DISABLED
Message-ID: <20131015194000.GG3703@kernel.dk>
References: <1381552427-6381-1-git-send-email-michael.opdenacker@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381552427-6381-1-git-send-email-michael.opdenacker@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 12 2013, Michael Opdenacker wrote:
> This patch proposes to remove the use of the IRQF_DISABLED flag
> 
> It's a NOOP since 2.6.35 and it will be removed one day.

Thanks, added for 3.13.

-- 
Jens Axboe

