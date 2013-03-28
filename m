Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756607Ab3C1QLW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 12:11:22 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:47433
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756355Ab3C1QLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 12:11:21 -0400
Date: Thu, 28 Mar 2013 10:11:14 -0600
From: Jens Axboe <axboe@kernel.dk>
To: Philipp Reisner <philipp.reisner@linbit.com>
Cc: linux-kernel@vger.kernel.org, drbd-dev@lists.linbit.com
Subject: Re: [PATCH 00/17] RFC: Pile of DRBD fixes
Message-ID: <20130328161114.GD19488@kernel.dk>
References: <1364389729-17559-1-git-send-email-philipp.reisner@linbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364389729-17559-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 27 2013, Philipp Reisner wrote:
> The first patch improves the idr_for_each_entry() macro and its
> documentation, which is not specific to DRBD.
> 
> Each patch in this series addresses an independent issue, please refer
> to the individual commit messages for a description.

Applied to for-3.10/drivers, thanks.

-- 
Jens Axboe

