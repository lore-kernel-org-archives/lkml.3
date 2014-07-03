Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758772AbaGCOVa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 10:21:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15493 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758554AbaGCOUu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 10:20:50 -0400
Message-ID: <53B566B7.9020505@redhat.com>
Date: Thu, 03 Jul 2014 15:20:39 +0100
From: Steven Whitehouse <swhiteho@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>,
        Jiri Kosina <trivial@kernel.org>
CC: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Subject: Re: [PATCH -trivial 4/4] GFS2: memcontrol: Spelling s/invlidate/invalidate/
References: <1404037299-31570-1-git-send-email-geert@linux-m68k.org> <1404037299-31570-4-git-send-email-geert@linux-m68k.org>
In-Reply-To: <1404037299-31570-4-git-send-email-geert@linux-m68k.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Now in the -nmw tree. Thanks,

Steve.

On 29/06/14 11:21, Geert Uytterhoeven wrote:
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: Steven Whitehouse <swhiteho@redhat.com>
> Cc: cluster-devel@redhat.com
> ---
>   fs/gfs2/glops.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/gfs2/glops.c b/fs/gfs2/glops.c
> index fc1100781bbc..2ffc67dce87f 100644
> --- a/fs/gfs2/glops.c
> +++ b/fs/gfs2/glops.c
> @@ -234,8 +234,8 @@ static void inode_go_sync(struct gfs2_glock *gl)
>    * inode_go_inval - prepare a inode glock to be released
>    * @gl: the glock
>    * @flags:
> - *
> - * Normally we invlidate everything, but if we are moving into
> + *
> + * Normally we invalidate everything, but if we are moving into
>    * LM_ST_DEFERRED from LM_ST_SHARED or LM_ST_EXCLUSIVE then we
>    * can keep hold of the metadata, since it won't have changed.
>    *

