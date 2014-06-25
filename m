Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757496AbaFYP4Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 11:56:16 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:60125 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757412AbaFYP4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 11:56:15 -0400
Message-ID: <53AAF128.1030800@kernel.dk>
Date: Wed, 25 Jun 2014 09:56:24 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Philipp Reisner <philipp.reisner@linbit.com>, linux-kernel@vger.kernel.org
CC: drbd-dev@lists.linbit.com
Subject: Re: [PATCH] drbd: fix NULL pointer deref in blk_add_request_payload
References: <1403711558-27267-1-git-send-email-philipp.reisner@linbit.com> <1403711558-27267-2-git-send-email-philipp.reisner@linbit.com>
In-Reply-To: <1403711558-27267-2-git-send-email-philipp.reisner@linbit.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25/2014 09:52 AM, Philipp Reisner wrote:
> From: Lars Ellenberg <lars.ellenberg@linbit.com>
> 
> Discards don't have any payload.
> But the scsi layer still expects a bio_vec it can use internally,
> see sd_setup_discard_cmnd() and blk_add_request_payload().
> 
> Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
> Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>

Applied, thanks.

-- 
Jens Axboe

