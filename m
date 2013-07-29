Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751947Ab3G2HvL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 03:51:11 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:25403 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143Ab3G2HvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 03:51:09 -0400
Date: Mon, 29 Jul 2013 10:50:30 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Dong Fang <yp.fangdong@gmail.com>
Cc: mfasheh@suse.com, jlbec@evilplan.org, akpm@linux-foundation.org,
        jeff.liu@oracle.com, viro@zeniv.linux.org.uk, sunil.mushran@gmail.com,
        tim.gardner@canonical.com, xuejiufei@huawei.com,
        shencanquan@huawei.com, ocfs2-devel@oss.oracle.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs/ocfs2: use list_for_each_entry() instead of
 list_for_each()
Message-ID: <20130729075029.GC5053@mwanda>
References: <1374902815-13349-1-git-send-email-yp.fangdong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374902815-13349-1-git-send-email-yp.fangdong@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't apply this patch.  Dong Fang sent a v2 later for some reason.

regards,
dan carpenter

