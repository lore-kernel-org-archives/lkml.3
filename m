Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753085AbaIWGpf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 02:45:35 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:26978 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751645AbaIWGpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 02:45:34 -0400
Message-ID: <54211707.8090604@huawei.com>
Date: Tue, 23 Sep 2014 14:45:27 +0800
From: Zefan Li <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <cgroups@vger.kernel.org>
Subject: Re: [GIT PULL] cgroup fixes for v3.17-rc6
References: <20140923063353.GK11740@mtj.dyndns.org>
In-Reply-To: <20140923063353.GK11740@mtj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020203.5421170C.007F,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: c3e56debbbc1106e7f965f31df1241c9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/9/23 14:33, Tejun Heo wrote:
> Hello, Linus.
> 
> One late fix for cgroup.  I was waiting for another set of fixes for a
> long-standing obscure cpuset bug but am not sure whether they'll be
> ready before v3.17 release.  This one is a simple fix for a mutex
> unlock balance bug, which is detected by coccinelle and probably won't
> trigger in the wild, introduced during this devel cycle.
> 

It was introduced in 3.14, and it was detected by my eyes, not coccinelle. ;)

