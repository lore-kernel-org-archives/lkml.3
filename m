Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758263Ab3FMChF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 22:37:05 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:16269 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757203Ab3FMChD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 22:37:03 -0400
Message-ID: <51B93038.9010202@huawei.com>
Date: Thu, 13 Jun 2013 10:36:40 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <containers@lists.linux-foundation.org>, <cgroups@vger.kernel.org>,
        <koverstreet@google.com>, <linux-kernel@vger.kernel.org>,
        <cl@linux-foundation.org>
Subject: Re: [PATCH 04/11] cgroup: use kzalloc() and list_del_init()
References: <1371070996-20613-1-git-send-email-tj@kernel.org> <1371070996-20613-5-git-send-email-tj@kernel.org>
In-Reply-To: <1371070996-20613-5-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/6/13 5:03, Tejun Heo wrote:
> There's no point in using kmalloc() and list_del() instead of the
> clearing variants for trivial stuff.  We can live dangerously
> elsewhere.  Use kzalloc() and list_del_init() instead and drop 0
> inits.
> 

Do you mean we prefer list_del_init() than list_del() in general? Then
in which cases do we prefer list_del()?

