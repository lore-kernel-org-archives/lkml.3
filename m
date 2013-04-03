Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762548Ab3DCFyr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 01:54:47 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:60246 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752486Ab3DCFyp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 01:54:45 -0400
MIME-Version: 1.0
In-Reply-To: <1364799360-23145-6-git-send-email-jaegeuk.kim@samsung.com>
References: <1364799360-23145-1-git-send-email-jaegeuk.kim@samsung.com>
	<1364799360-23145-6-git-send-email-jaegeuk.kim@samsung.com>
Date: Wed, 3 Apr 2013 14:54:44 +0900
Message-ID: <CAKYAXd_iq4MWnT6jAzjtkzbN8+6zaiC0NG0yzFB8b=eTxj1MXw@mail.gmail.com>
Subject: Re: [PATCH 6/9] f2fs: check completion of foreground GC
From: Namjae Jeon <linkinjeon@gmail.com>
To: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/4/1, Jaegeuk Kim <jaegeuk.kim@samsung.com>:
> The foreground GCs are triggered under not enough free sections.
> So, we should not skip moving valid blocks in the victim segments.
>
> Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Looks good to me~
Reviewed-by: Namjae Jeon <namjae.jeon@samsung.com>

Thanks.
