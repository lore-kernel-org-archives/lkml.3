Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932472Ab3E0N3f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 09:29:35 -0400
Received: from mail-qc0-f173.google.com ([209.85.216.173]:38429 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758017Ab3E0N3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 09:29:34 -0400
MIME-Version: 1.0
In-Reply-To: <1368822464-4887-1-git-send-email-rabin@rab.in>
References: <1368822464-4887-1-git-send-email-rabin@rab.in>
From: Rabin Vincent <rabin@rab.in>
Date: Mon, 27 May 2013 15:28:53 +0200
X-Google-Sender-Auth: aMWENSDyHSv53qu6R2RCOfQf8Rc
Message-ID: <CAH+eYFC9F6cLpwYPg7iC2cOsKBJ3P9zEB=VTdA-fFDTPi1bTmQ@mail.gmail.com>
Subject: Re: [PATCH] tools lib lk: respect CROSS_COMPILE
To: acme@redhat.com, mingo@kernel.org, paulus@samba.org,
        a.p.zijlstra@chello.nl
Cc: bp@suse.de, linux-kernel@vger.kernel.org, Rabin Vincent <rabin@rab.in>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/5/17 Rabin Vincent <rabin@rab.in>:
> Make lk use CROSS_COMPILE, in order to be able to cross compile perf
> again.
>
> Signed-off-by: Rabin Vincent <rabin@rab.in>

Ping.  Would be nice if this was merged so that perf cross compile is no longer
broken.

> ---
>  tools/lib/lk/Makefile | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/tools/lib/lk/Makefile b/tools/lib/lk/Makefile
> index 926cbf3..2c5a197 100644
> --- a/tools/lib/lk/Makefile
> +++ b/tools/lib/lk/Makefile
> @@ -1,5 +1,8 @@
>  include ../../scripts/Makefile.include
>
> +CC = $(CROSS_COMPILE)gcc
> +AR = $(CROSS_COMPILE)ar
> +
>  # guard against environment variables
>  LIB_H=
>  LIB_OBJS=
> --
> 1.8.1.2
>
