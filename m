Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751907AbaEBJhx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 05:37:53 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:56029 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353AbaEBJhu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 05:37:50 -0400
MIME-Version: 1.0
In-Reply-To: <5363655D.6020408@gmail.com>
References: <5363655D.6020408@gmail.com>
From: Michael Kerrisk <mtk.manpages@gmail.com>
Date: Fri, 2 May 2014 11:37:29 +0200
X-Google-Sender-Auth: zy07dZUqaijXH_B2f1wD_C-zXZg
Message-ID: <CAHO5Pa1+jLa8fu675bEZM=fqiOWmWv1DvL_JfQsTsBXXp7u0JQ@mail.gmail.com>
Subject: Re: [patch] timer_stats, doc: Readout of /proc/timer_stats doesn't
 disable sampling
To: Ingo Molnar <mingo@elte.hu>
Cc: Michael Kerrisk-manpages <mtk.manpages@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry -- fatfingered in Thunderbird. Proper patch on its way shortly.

On Fri, May 2, 2014 at 11:29 AM, Michael Kerrisk (man-pages)
<mtk.manpages@gmail.com> wrote:
> From: Michael Kerrisk <mtk.manpages@gmail.com>
>
> Some simple testing shows that reading from /proc/timer_stats
> does not disable sampling. Looking back over past source code,
> it appears that it never did.
>
> Signed-off-by: Michael Kerrisk <mtk.manpages@gmail.com>
>
>
> --
> Michael Kerrisk
> Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
> Linux/UNIX System Programming Training: http://man7.org/training/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
Michael Kerrisk Linux man-pages maintainer;
http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface", http://blog.man7.org/
