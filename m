Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756885Ab3EGRen (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 13:34:43 -0400
Received: from mail-lb0-f180.google.com ([209.85.217.180]:33707 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752490Ab3EGRel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 13:34:41 -0400
Message-ID: <51893B2F.6070602@cogentembedded.com>
Date: Tue, 07 May 2013 21:34:39 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Jeff Garzik <jgarzik@pobox.com>, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org
Subject: Re: [GIT PULL] libata maintainership update
References: <20130507171921.GB5531@mtj.dyndns.org>
In-Reply-To: <20130507171921.GB5531@mtj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 07-05-2013 21:19, Tejun Heo wrote:

> As discussed earlier, Jeff is leaving for something more fun and I'm
> inheriting the maintainership of libata.  Please pull from the
> following branch to receive MAINTAINERS update.

>    git://git.kernel.org/pub/scm/linux/kernel/git/tj/libata.git for-3.10

> I'll manage it similarly to other trees I'm maintaining.  When X-rc1
> drops, for-X-fixes and for-X+1 are created on top of it and for-next
> will be pulling in both branches.

> Thanks!

> --
> tejun

> ----------------------------------------------------------------
> Tejun Heo (1):
>        libata: change maintainer

>   MAINTAINERS | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)

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

    I think you've forgotten to update the git tree to yours.

MBR, Sergei

