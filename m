Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751241AbaDNB1n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2014 21:27:43 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:46328 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750779AbaDNB1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2014 21:27:41 -0400
X-IronPort-AV: E=Sophos;i="4.97,853,1389715200"; 
   d="scan'208";a="29207270"
Message-ID: <534B374C.8030009@cn.fujitsu.com>
Date: Mon, 14 Apr 2014 09:18:04 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Kim <jaegeuk.kim@samsung.com>
CC: f2fs <linux-f2fs-devel@lists.sourceforge.net>,
        fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/7] f2fs: some fix and cleanup about flush_merge
References: <5347BAA5.6070104@cn.fujitsu.com>
In-Reply-To: <5347BAA5.6070104@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.100]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,
There seems to be a mistake in "[PATCH 2/7]f2fs: remove the unuseful "issue_tail" list",
and the whole patchset needs to be reworked. So please ignore this one.
Sorry for the noise.

Regards,
Gu
On 04/11/2014 05:49 PM, Gu Zheng wrote:

> Gu Zheng (7):
>   f2fs: put the bio when issue_flush completed
>   f2fs: remove the unuseful "issue_tail" list
>   f2fs: use __GFP_ZERO to avoid appending set-NULL
>   f2fs: enable flush_merge only in f2fs is not read-only
>   f2fs: add the flush_merge handle in the remount flow
>   f2fs: introduce struct flush_cmd_control to wrap the flush_merge
>     fields
>   f2fs: introduce help function {create,destroy}_flush_cmd_control
> 
>  fs/f2fs/f2fs.h    |   17 ++++++---
>  fs/f2fs/segment.c |  102 +++++++++++++++++++++++++++++++++++-----------------
>  fs/f2fs/super.c   |   32 ++++++++++++++--
>  3 files changed, 107 insertions(+), 44 deletions(-)
> 


