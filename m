Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757213Ab3G3FCE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 01:02:04 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:31438 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753409Ab3G3FCD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 01:02:03 -0400
Message-ID: <51F748AA.4060706@oracle.com>
Date: Tue, 30 Jul 2013 13:01:30 +0800
From: Jeff Liu <jeff.liu@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
To: Dong Fang <yp.fangdong@gmail.com>
CC: Dan Carpenter <dan.carpenter@oracle.com>, mfasheh@suse.com,
        jlbec@evilplan.org, akpm@linux-foundation.org, viro@zeniv.linux.org.uk,
        sunil.mushran@gmail.com, tim.gardner@canonical.com,
        xuejiufei@huawei.com, shencanquan@huawei.com,
        ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v2] fs/ocfs2: use list_for_each_entry() instead of list_for_each()
References: <1374931429-14062-1-git-send-email-yp.fangdong@gmail.com> <20130729074928.GB5053@mwanda> <20130729080606.GD5053@mwanda> <51F7E332.5010708@gmail.com>
In-Reply-To: <51F7E332.5010708@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dong,

On 07/31/2013 12:00 AM, Dong Fang wrote:

> On 07/29/2013 04:06 AM, Dan Carpenter wrote:
>> Oh.  It appears that nothing changed between v1 and v2.  Only the CC
>> list.
>>
>> It's probably that the list moderation on ocfs2-devel was confusing
>> for non-native English speakers the patch submitter thought his
>> patch was dropped.
>>
>> Also mailing lists should have a white list so that I don't get the
>> message every single time.
>>
>> regards,
>> dan carpenter
>>
> sorry about that, i just think i shoud send this patch to linux-fsdevel,
> but ./get_maintainer.pl didn't tell me

It's better to send this patch to ocfs2-devel@oss.oracle.com only, as this
is a specific patch for OCFS2.

Also, we tag OCFS2 kernel patch with "ocfs2" in subject line rather than "fs/ocfs2".

Thanks,
-Jeff
