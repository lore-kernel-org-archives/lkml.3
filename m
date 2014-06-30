Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753045AbaF3PaY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 11:30:24 -0400
Received: from mx4-phx2.redhat.com ([209.132.183.25]:43041 "EHLO
	mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214AbaF3PaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 11:30:23 -0400
Date: Mon, 30 Jun 2014 11:30:16 -0400 (EDT)
From: Bob Peterson <rpeterso@redhat.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Jiri Kosina <trivial@kernel.org>, cluster-devel@redhat.com,
        linux-kernel@vger.kernel.org
Message-ID: <1896340514.622143.1404142216566.JavaMail.zimbra@redhat.com>
In-Reply-To: <1404037299-31570-4-git-send-email-geert@linux-m68k.org>
References: <1404037299-31570-1-git-send-email-geert@linux-m68k.org> <1404037299-31570-4-git-send-email-geert@linux-m68k.org>
Subject: Re: [Cluster-devel] [PATCH -trivial 4/4] GFS2: memcontrol: Spelling
	s/invlidate/invalidate/
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.82.12]
X-Mailer: Zimbra 8.0.6_GA_5922 (ZimbraWebClient - FF30 (Linux)/8.0.6_GA_5922)
Thread-Topic: GFS2: memcontrol: Spelling s/invlidate/invalidate/
Thread-Index: zGW1uJ41eba7s+Ez/k8t+R4k4EZrwg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: Steven Whitehouse <swhiteho@redhat.com>
> Cc: cluster-devel@redhat.com
> ---
>  fs/gfs2/glops.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/gfs2/glops.c b/fs/gfs2/glops.c
> index fc1100781bbc..2ffc67dce87f 100644
> --- a/fs/gfs2/glops.c
> +++ b/fs/gfs2/glops.c
> @@ -234,8 +234,8 @@ static void inode_go_sync(struct gfs2_glock *gl)
>   * inode_go_inval - prepare a inode glock to be released
>   * @gl: the glock
>   * @flags:
> - *
> - * Normally we invlidate everything, but if we are moving into
> + *
> + * Normally we invalidate everything, but if we are moving into
>   * LM_ST_DEFERRED from LM_ST_SHARED or LM_ST_EXCLUSIVE then we
>   * can keep hold of the metadata, since it won't have changed.
>   *
> --
> 1.9.1

Hi Geert,

ACK,

Steve is on holiday this week, but he will likely add it to the GFS2 nmw
git repo when he returns.

Regards,

Bob Peterson
Red Hat File Systems
