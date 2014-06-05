Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752999AbaFEBty (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 21:49:54 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:21544 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751443AbaFEBtw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 21:49:52 -0400
Message-ID: <538FCCA3.8060108@huawei.com>
Date: Thu, 5 Jun 2014 09:49:23 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH 2/3] cgroup: make the default root invisible when it's
 umounted
References: <538D4956.5050205@huawei.com> <538D4982.10905@huawei.com> <20140603130144.GB26210@htj.dyndns.org> <538EE00F.10406@huawei.com> <20140605012011.GB14370@mtj.dyndns.org>
In-Reply-To: <20140605012011.GB14370@mtj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/6/5 9:20, Tejun Heo wrote:
> Hello,
> 
> On Wed, Jun 04, 2014 at 04:59:59PM +0800, Li Zefan wrote:
>> The example I gave is the same result if sane_behavior is not specified,
>> so this is a behavioural change for the old interface?
> 
> Hmmm?  Either the userland knows about unified hierarchy or not and
> there's no point in hiding it if we know that userland knows.  It's
> really a system-wide thing which happens once.
> 

Yeah, it's reasonable.

I thought "mount -t cgroup xxx /cgroup" will mount the default hierarchy,
but I was wrong.

