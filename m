Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760299Ab3DCBRW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 21:17:22 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:51111 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753390Ab3DCBRV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 21:17:21 -0400
MIME-Version: 1.0
In-Reply-To: <1364799360-23145-2-git-send-email-jaegeuk.kim@samsung.com>
References: <1364799360-23145-1-git-send-email-jaegeuk.kim@samsung.com>
	<1364799360-23145-2-git-send-email-jaegeuk.kim@samsung.com>
Date: Wed, 3 Apr 2013 10:17:20 +0900
Message-ID: <CAKYAXd-c8J=3bUdCY_0PsL8+c7rnkaFMTQABiu2xc_EvHijjCw@mail.gmail.com>
Subject: Re: [PATCH 2/9] f2fs: introduce TOTAL_SECS macro
From: Namjae Jeon <linkinjeon@gmail.com>
To: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/4/1, Jaegeuk Kim <jaegeuk.kim@samsung.com>:
> Let's use a macro to get the total number of sections.
>
> Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Looks reasonable to me~
Reviewed-by: Namjae Jeon <namjae.jeon@samsung.com>

Thanks.
> ---
