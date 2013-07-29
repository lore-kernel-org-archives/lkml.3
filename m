Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752756Ab3G2IHG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 04:07:06 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:34014 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751942Ab3G2IHC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 04:07:02 -0400
Date: Mon, 29 Jul 2013 11:06:06 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Dong Fang <yp.fangdong@gmail.com>
Cc: mfasheh@suse.com, jlbec@evilplan.org, akpm@linux-foundation.org,
        jeff.liu@oracle.com, viro@zeniv.linux.org.uk, sunil.mushran@gmail.com,
        tim.gardner@canonical.com, xuejiufei@huawei.com,
        shencanquan@huawei.com, ocfs2-devel@oss.oracle.com,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v2] fs/ocfs2: use list_for_each_entry() instead of
 list_for_each()
Message-ID: <20130729080606.GD5053@mwanda>
References: <1374931429-14062-1-git-send-email-yp.fangdong@gmail.com>
 <20130729074928.GB5053@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130729074928.GB5053@mwanda>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oh.  It appears that nothing changed between v1 and v2.  Only the CC
list.

It's probably that the list moderation on ocfs2-devel was confusing
for non-native English speakers the patch submitter thought his
patch was dropped.

Also mailing lists should have a white list so that I don't get the
message every single time.

regards,
dan carpenter
