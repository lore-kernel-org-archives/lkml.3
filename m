Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759548Ab3EGV0D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 17:26:03 -0400
Received: from mail-ye0-f182.google.com ([209.85.213.182]:35540 "EHLO
	mail-ye0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757627Ab3EGV0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 17:26:00 -0400
Message-ID: <51896BDF.5070101@pobox.com>
Date: Tue, 07 May 2013 17:02:23 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [GIT PULL] libata maintainership update
References: <20130507171921.GB5531@mtj.dyndns.org>
In-Reply-To: <20130507171921.GB5531@mtj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07/2013 01:19 PM, Tejun Heo wrote:
> Hello, Linus, Jeff, linux-ide folks.
>
> As discussed earlier, Jeff is leaving for something more fun and I'm
> inheriting the maintainership of libata.  Please pull from the
> following branch to receive MAINTAINERS update.
>
>    git://git.kernel.org/pub/scm/linux/kernel/git/tj/libata.git for-3.10
>
> I'll manage it similarly to other trees I'm maintaining.  When X-rc1
> drops, for-X-fixes and for-X+1 are created on top of it and for-next
> will be pulling in both branches.
>
> Thanks!
>
> --
> tejun
>
> ----------------------------------------------------------------
> Tejun Heo (1):
>        libata: change maintainer
>
>   MAINTAINERS | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index e1f5fac..c5ed056 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -7140,7 +7140,7 @@ F:	drivers/misc/phantom.c
>   F:	include/uapi/linux/phantom.h
>
>   SERIAL ATA (SATA) SUBSYSTEM
> -M:	Jeff Garzik <jgarzik@pobox.com>
> +M:	Tejun Heo <tj@kernel.org>
>   L:	linux-ide@vger.kernel.org
>   T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/libata-dev.git
>   S:	Supported

You probably also want to change

* the git tree URL quoted above
* a ton of source files themselves say "maintained by Jeff Garzik and 
linux-ide"



