Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757414Ab3BGB37 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 20:29:59 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:37580 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754804Ab3BGB35 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 20:29:57 -0500
Message-ID: <5113038C.8040909@huawei.com>
Date: Thu, 7 Feb 2013 09:29:48 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <containers@lists.linux-foundation.org>, <cgroups@vger.kernel.org>
Subject: Re: [PATCH 14/77] cgroup: don't use idr_remove_all()
References: <1360179649-22465-1-git-send-email-tj@kernel.org> <1360179649-22465-15-git-send-email-tj@kernel.org>
In-Reply-To: <1360179649-22465-15-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/2/7 3:39, Tejun Heo wrote:
> idr_destroy() can destroy idr by itself and idr_remove_all() is being
> deprecated.  Drop its usage.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>

Acked-by: Li Zefan <lizefan@huawei.com>

