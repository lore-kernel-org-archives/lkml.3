Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758524Ab3BGMgh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 07:36:37 -0500
Received: from merlin.infradead.org ([205.233.59.134]:34782 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758460Ab3BGMgd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 07:36:33 -0500
Date: Thu, 7 Feb 2013 13:35:27 +0100
From: Jens Axboe <axboe@kernel.dk>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, Wanlong Gao <gaowanlong@cn.fujitsu.com>,
        asias@redhat.com, Rusty Russell <rusty@rustcorp.com.au>,
        mst@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [RFC PATCH 5/8] scatterlist: introduce sg_unmark_end
Message-ID: <20130207123527.GA15092@kernel.dk>
References: <1360239752-2470-1-git-send-email-pbonzini@redhat.com>
 <1360239752-2470-6-git-send-email-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360239752-2470-6-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 07 2013, Paolo Bonzini wrote:
> This is useful in places that recycle the same scatterlist multiple
> times, and do not want to incur the cost of sg_init_table every
> time in hot paths.

Looks fine to me.

Acked-by: Jens Axboe <axboe@kernel.dk>

-- 
Jens Axboe

