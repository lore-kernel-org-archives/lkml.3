Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932884AbaJUTZP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 15:25:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53703 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932831AbaJUTZN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 15:25:13 -0400
Message-ID: <1413919512.2350.3.camel@redhat.com>
Subject: Re: [PATCH] audit: add Paul Moore to the MAINTAINERS entry
From: Eric Paris <eparis@redhat.com>
To: Paul Moore <pmoore@redhat.com>
Cc: linux-audit@redhat.com, linux-kernel@vger.kernel.org
Date: Tue, 21 Oct 2014 15:25:12 -0400
In-Reply-To: <20141020162328.1159.33576.stgit@localhost>
References: <20141020162328.1159.33576.stgit@localhost>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-10-20 at 12:23 -0400, Paul Moore wrote:
> After a long stint maintaining the audit tree, Eric asked me to step
> in and handle the day-to-day management of the audit tree.  We should
> also update the linux-audit mailing list entry to better reflect
> current usage.
> 
> Signed-off-by: Paul Moore <pmoore@redhat.com>

Acked-by: Eric Paris <eparis@redhat.com>

> ---
>  MAINTAINERS |    5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index c2066f4..86c24fd 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -1689,10 +1689,11 @@ S:	Supported
>  F:	drivers/scsi/esas2r
>  
>  AUDIT SUBSYSTEM
> +M:	Paul Moore <paul@paul-moore.com>
>  M:	Eric Paris <eparis@redhat.com>
> -L:	linux-audit@redhat.com (subscribers-only)
> +L:	linux-audit@redhat.com (moderated for non-subscribers)
>  W:	http://people.redhat.com/sgrubb/audit/
> -T:	git git://git.infradead.org/users/eparis/audit.git
> +T:	git git://git.infradead.org/users/pcmoore/audit
>  S:	Maintained
>  F:	include/linux/audit.h
>  F:	include/uapi/linux/audit.h
> 


