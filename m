Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933950Ab3CZAtb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 20:49:31 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:41062 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933924Ab3CZAt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 20:49:26 -0400
MIME-Version: 1.0
In-Reply-To: <1364168414-12815-3-git-send-email-jaegeuk.kim@samsung.com>
References: <1364168414-12815-1-git-send-email-jaegeuk.kim@samsung.com>
	<1364168414-12815-3-git-send-email-jaegeuk.kim@samsung.com>
Date: Tue, 26 Mar 2013 09:49:26 +0900
Message-ID: <CAKYAXd8CBoG7=FL8yuJ3gfp9Les5i1nGmG1AqeaF0wnzOKJOoA@mail.gmail.com>
Subject: Re: [PATCH 3/4] f2fs: remain nat cache entries for further free nid allocation
From: Namjae Jeon <linkinjeon@gmail.com>
To: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/3/25, Jaegeuk Kim <jaegeuk.kim@samsung.com>:
> In the checkpoint flow, the f2fs investigates the total nat cache entries.
> Previously, if an entry has NULL_ADDR, f2fs drops the entry and adds the
> obsolete nid to the free nid list.
> However, this free nid will be reused sooner, resulting in its nat entry
> miss.
> In order to avoid this, we don't need to drop the nat cache entry at this
> moment.
>
> Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Looks good to me.
Reviewed-by: Namjae Jeon <namjae.jeon@samsung.com>

Thanks~
