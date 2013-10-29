Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752331Ab3J2Ugx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 16:36:53 -0400
Received: from merlin.infradead.org ([205.233.59.134]:59253 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751804Ab3J2Ugw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 16:36:52 -0400
Date: Tue, 29 Oct 2013 14:36:47 -0600
From: Jens Axboe <axboe@kernel.dk>
To: Kent Overstreet <kmo@daterainc.com>
Cc: linux-kernel@vger.kernel.org, hch@infradead.org, tj@kernel.org,
        nab@linux-iscsi.org
Subject: Re: [PATCH] Immutable biovecs
Message-ID: <20131029203647.GH22549@kernel.dk>
References: <1383077896-4132-1-git-send-email-kmo@daterainc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383077896-4132-1-git-send-email-kmo@daterainc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 29 2013, Kent Overstreet wrote:
> Jens - this patch series is ready to go, driver maintainers have reviewed and
> tested it and the code's been essentially done for probably a year now - can we
> get this into 3.13?

We can - your series doesn't apply to for-3.13/core however, can you
check?

-- 
Jens Axboe

