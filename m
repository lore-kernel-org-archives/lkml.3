Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751402Ab3G3KoO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 06:44:14 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:59170 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877Ab3G3KoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 06:44:13 -0400
Message-ID: <51F84172.50408@gmail.com>
Date: Tue, 30 Jul 2013 18:42:58 -0400
From: Dong Fang <yp.fangdong@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: akpm@linux-foundation.org, jeff.liu@oracle.com, xuejiufei@huawei.com,
        shencanquan@huawei.com, ocfs2-devel@oss.oracle.com,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v2] fs/ocfs2: use list_for_each_entry() instead of list_for_each()
References: <1374931429-14062-1-git-send-email-yp.fangdong@gmail.com> <20130729074928.GB5053@mwanda> <20130729080606.GD5053@mwanda>
In-Reply-To: <20130729080606.GD5053@mwanda>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29/2013 04:06 AM, Dan Carpenter wrote:
> Oh.  It appears that nothing changed between v1 and v2.  Only the CC
> list.
>
> It's probably that the list moderation on ocfs2-devel was confusing
> for non-native English speakers the patch submitter thought his
> patch was dropped.
>
> Also mailing lists should have a white list so that I don't get the
> message every single time.
>
> regards,
> dan carpenter
>
hi, dan carpenter.

i am not a member of Ocfs2-devel mailing list, after i send this patch,
it notice me "Your message to Ocfs2-devel awaits moderator approval".
i subscribe this mailing list just now, do you think i need to resend
this patch to Ocfs2-devel ?

thx very much.
