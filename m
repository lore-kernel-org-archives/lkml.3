Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932458Ab3LIJQR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 04:16:17 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:58658 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932191Ab3LIJQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 04:16:15 -0500
Message-ID: <52A58A4A.6030608@huawei.com>
Date: Mon, 9 Dec 2013 17:15:54 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <containers@lists.linux-foundation.org>, <cgroups@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <vdavydov@parallels.com>
Subject: Re: [PATCHSET REPOST cgroup/for-3.14] cgroup: factor out css creation
 into create_css()
References: <1386361672-27791-1-git-send-email-tj@kernel.org>
In-Reply-To: <1386361672-27791-1-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/12/7 4:27, Tejun Heo wrote:
> Hello,
> 
> This is repost of the following.
> 
>  http://thread.gmane.org/gmane.linux.kernel.cgroups/8981
> 
> It got reviewed and acked then but I somehow forgot apply and Vladimir
> reporting the same bug that the first patch in the original patch
> fixed reminded me.  The first patch is already applied to
> cgroup/for-3.13-fixes which is pulled into for-3.14 for this series.

Yeah, that's why I have a vivid memory that the bug has already been
fixed when I saw Vladimir's bug report. :)

