Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755959AbaA2Dh0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 22:37:26 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:37700 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755911AbaA2DhW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 22:37:22 -0500
Message-ID: <52E87768.8040300@huawei.com>
Date: Wed, 29 Jan 2014 11:37:12 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <containers@lists.linux-foundation.org>, <cgroups@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH 2/4] cgroup: fix error return from cgroup_create()
References: <1390923125-4369-1-git-send-email-tj@kernel.org> <1390923125-4369-3-git-send-email-tj@kernel.org>
In-Reply-To: <1390923125-4369-3-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/1/28 23:32, Tejun Heo wrote:
> cgroup_create() was returning 0 after allocation failures.  Fix it.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: stable@vger.kernel.org

Acked-by: Li Zefan <lizefan@huawei.com>
