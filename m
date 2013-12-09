Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933020Ab3LIJLM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 04:11:12 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:43822 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932104Ab3LIJLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 04:11:06 -0500
Message-ID: <52A58916.4070708@huawei.com>
Date: Mon, 9 Dec 2013 17:10:46 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Vladimir Davydov <vdavydov@parallels.com>, <linux-kernel@vger.kernel.org>,
        <cgroups@vger.kernel.org>, <devel@openvz.org>
Subject: Re: [PATCH cgroup/for-3.13-fixes] cgroup: fix oops in cgroup init
 failure path
References: <1386234006-1633-1-git-send-email-vdavydov@parallels.com> <20131205211814.GA29598@mtj.dyndns.org>
In-Reply-To: <20131205211814.GA29598@mtj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/12/6 5:18, Tejun Heo wrote:
> Hello, Vladimir.
> 
> Thanks a lot for the report and fix; however, I really wanna make sure
> that only online css's become visible, so I wrote up a different fix.
> Can you please test this one?
> 

Oh, I spotted this bug when reviewing a bug fix months ago.

http://lkml.org/lkml/2013/9/2/135

but that bug fix didn't go into mainline and it still exists even after
the below fix.

This is your updated fix that fixes both bugs.

http://lkml.org/lkml/2013/9/3/502

