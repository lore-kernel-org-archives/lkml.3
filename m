Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757756Ab3HBD0N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 23:26:13 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:54115 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757515Ab3HBD0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 23:26:12 -0400
Message-ID: <51FB26C6.2020100@huawei.com>
Date: Fri, 2 Aug 2013 11:25:58 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <containers@lists.linux-foundation.org>, <cgroups@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 16/23] cgroup: relocate cgroup_advance_iter()
References: <1375393801-4817-1-git-send-email-tj@kernel.org> <1375393801-4817-17-git-send-email-tj@kernel.org>
In-Reply-To: <1375393801-4817-17-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/8/2 5:49, Tejun Heo wrote:
> For some reason, cgroup_advance_iter() is standing lonely all away
> from its iter comrades.  Relocate it.
> 

There're some other functions that are in the same situation. Do you
think it's better to relocate them, or just leave it as it is?

