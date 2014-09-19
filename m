Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753818AbaISI6N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 04:58:13 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:16955 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204AbaISI6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 04:58:11 -0400
Message-ID: <541BF01E.5020803@huawei.com>
Date: Fri, 19 Sep 2014 16:58:06 +0800
From: Zefan Li <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] cgroup: remove CGRP_RELEASABLE flag
References: <541BEE74.6020008@huawei.com>
In-Reply-To: <541BEE74.6020008@huawei.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020206.541BF021.008A,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: 8e4b6faceafaa2c0792d1449156f254c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The subject should be "[PATCH] ...".

On 2014/9/19 16:51, Zefan Li wrote:
> We call put_css_set() after setting CGRP_RELEASABLE flag in
> cgroup_task_migrate(), but in other places we call it without setting
> the flag. I don't see the necessity of this flag.
> 


