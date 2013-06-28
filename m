Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754904Ab3F1OFa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 10:05:30 -0400
Received: from merlin.infradead.org ([205.233.59.134]:52212 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754444Ab3F1OF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 10:05:29 -0400
Date: Fri, 28 Jun 2013 16:05:24 +0200
From: Jens Axboe <axboe@kernel.dk>
To: Philipp Reisner <philipp.reisner@linbit.com>
Cc: linux-kernel@vger.kernel.org, drbd-dev@lists.linbit.com
Subject: Re: [PATCH 0/6] DRBD fixes and one functional enhancemet
Message-ID: <20130628140524.GL24293@kernel.dk>
References: <1372171808-30515-1-git-send-email-philipp.reisner@linbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372171808-30515-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 25 2013, Philipp Reisner wrote:
> Hi Jens,
> 
> Please consider to apply these patches to your for-3.11/drivers branch.
> 
> The first 4 patches are obvious fixes. The last patch adds
> the capability to change the activity log layout online.
> (al-stripes and al-stripe-size)
> 
> I posted these patches on the 14th for review.

Thanks, added for 3.11.

-- 
Jens Axboe

