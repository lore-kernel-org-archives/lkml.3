Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751491Ab3IUT6Y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Sep 2013 15:58:24 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53087 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179Ab3IUT6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Sep 2013 15:58:23 -0400
Date: Sat, 21 Sep 2013 13:58:14 -0600
From: Jens Axboe <axboe@kernel.dk>
To: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Cc: device-mapper development <dm-devel@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Frank Mayhar <fmayhar@google.com>, Mike Snitzer <snitzer@redhat.com>,
        Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH] block: Add nr_bios to block_rq_remap tracepoint
Message-ID: <20130921195814.GE2312@kernel.dk>
References: <523835AD.1030300@ce.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <523835AD.1030300@ce.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 17 2013, Jun'ichi Nomura wrote:
> Adding the number of bios in a remapped request to 'block_rq_remap'
> tracepoint.
> 
> Request remapper clones bios in a request to track the completion
> status of each bio. So the number of bios can be useful information
> for investigation.
> 
> Related discussions:
>   http://www.redhat.com/archives/dm-devel/2013-August/msg00084.html
>   http://www.redhat.com/archives/dm-devel/2013-September/msg00024.html
> 
> Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
> Acked-by: Mike Snitzer <snitzer@redhat.com>
> Cc: Jens Axboe <axboe@kernel.dk>

Thanks, added.

-- 
Jens Axboe

