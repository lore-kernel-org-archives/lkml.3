Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755081Ab3LDCQV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 21:16:21 -0500
Received: from merlin.infradead.org ([205.233.59.134]:36082 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752764Ab3LDCQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 21:16:19 -0500
Date: Tue, 3 Dec 2013 19:16:15 -0700
From: Jens Axboe <axboe@kernel.dk>
To: Mike Snitzer <snitzer@redhat.com>
Cc: kmo@daterainc.com, dm-devel@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dm cache: increment bi_remaining when bi_end_io is
 restored
Message-ID: <20131204021615.GD5051@kernel.dk>
References: <1386114899-7766-1-git-send-email-snitzer@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386114899-7766-1-git-send-email-snitzer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 03 2013, Mike Snitzer wrote:
> Move the bio->bi_remaining increment into dm_unhook_bio() so the
> overwrite_endio() handler works as expected.
> 
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> ---
>  drivers/md/dm-cache-target.c |   12 ++++++------
>  1 files changed, 6 insertions(+), 6 deletions(-)
> 
> [Jens: this one would've been needed as a post-merge fix for v3.13 but
>  immutable biovecs fell out.. please apply to your for-3.14/core]

Thanks Mike, applied.

-- 
Jens Axboe

