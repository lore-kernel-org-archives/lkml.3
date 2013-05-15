Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759604Ab3EOQmK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 12:42:10 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:51772 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758966Ab3EOQmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 12:42:08 -0400
Message-ID: <5193BADF.2050302@inktank.com>
Date: Wed, 15 May 2013 11:42:07 -0500
From: Alex Elder <elder@inktank.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Jim Schutt <jaschut@sandia.gov>
CC: ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] ceph: fix up comment for ceph_count_locks() as
 to which lock to hold
References: <1368635894-114707-1-git-send-email-jaschut@sandia.gov> <1368635894-114707-2-git-send-email-jaschut@sandia.gov>
In-Reply-To: <1368635894-114707-2-git-send-email-jaschut@sandia.gov>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/15/2013 11:38 AM, Jim Schutt wrote:
> 
> Signed-off-by: Jim Schutt <jaschut@sandia.gov>

Looks good.

Reviewed-by: Alex Elder <elder@inktank.com>

> ---
>  fs/ceph/locks.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ceph/locks.c b/fs/ceph/locks.c
> index 202dd3d..ffc86cb 100644
> --- a/fs/ceph/locks.c
> +++ b/fs/ceph/locks.c
> @@ -169,7 +169,7 @@ int ceph_flock(struct file *file, int cmd, struct file_lock *fl)
>  }
>  
>  /**
> - * Must be called with BKL already held. Fills in the passed
> + * Must be called with lock_flocks() already held. Fills in the passed
>   * counter variables, so you can prepare pagelist metadata before calling
>   * ceph_encode_locks.
>   */
> 

