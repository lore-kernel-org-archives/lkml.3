Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753079AbaBMCDo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 21:03:44 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:7893 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753019AbaBMCDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 21:03:43 -0500
Message-ID: <52FC2779.9080905@huawei.com>
Date: Thu, 13 Feb 2014 10:01:29 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <containers@lists.linux-foundation.org>, <cgroups@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 09/16] cgroup: remove css_scan_tasks()
References: <1391953964-22088-1-git-send-email-tj@kernel.org> <1391953964-22088-10-git-send-email-tj@kernel.org>
In-Reply-To: <1391953964-22088-10-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/2/9 21:52, Tejun Heo wrote:
> css_scan_tasks() doesn't have any user left.  Remove it.
> 

I always dislike css_scan_tasks().

