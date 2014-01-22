Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754929AbaAVEge (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 23:36:34 -0500
Received: from merlin.infradead.org ([205.233.59.134]:45232 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805AbaAVEgd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 23:36:33 -0500
Date: Tue, 21 Jan 2014 20:36:31 -0800
From: Jens Axboe <axboe@kernel.dk>
To: Christian Engelmayer <cengelma@gmx.at>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] block: Fix memory leak in rw_copy_check_uvector()
 handling
Message-ID: <20140122043631.GJ20347@kernel.dk>
References: <20140119020849.26de4fb0@spike>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140119020849.26de4fb0@spike>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 19 2014, Christian Engelmayer wrote:
> Fix a memory leak in the error handling path of function sg_io()
> that is used during the processing of scsi ioctl. Memory already
> allocated by rw_copy_check_uvector() needs to be freed correctly.
> Detected by Coverity: CID 1128953.

Applied, thanks.

-- 
Jens Axboe

