Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751441AbaDOC7O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 22:59:14 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:37976 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790AbaDOC7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 22:59:12 -0400
Message-ID: <534CA050.8060709@huawei.com>
Date: Tue, 15 Apr 2014 10:58:24 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Vivek Goyal <vgoyal@redhat.com>, <containers@lists.linux-foundation.org>,
        <cgroups@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHSET cgroup/for-3.15] cgroup: implement unified hierarchy
References: <1395974461-12735-1-git-send-email-tj@kernel.org> <20140414154556.GA9552@redhat.com> <20140414175236.GB15249@htj.dyndns.org> <20140414181421.GC9552@redhat.com> <20140414192139.GB16835@htj.dyndns.org>
In-Reply-To: <20140414192139.GB16835@htj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

on 2014/4/15 3:21, Tejun Heo wrote:
> Hello,
> 
> On Mon, Apr 14, 2014 at 02:14:21PM -0400, Vivek Goyal wrote:
>> So is this an intermediate mode before we move to single hiearchy *only*
>> mode. AFAIK, you had mentioned that we will support legacy multiple
>> hiearchy mode but single hiearchy is the new default mode.
> 
> Hmmm?  It's a separate special hierarchy which can co-exist with other
> hierarchies.  There's no inherent intermediacy to it.  As long as
> traditional hierarchies exist, it's gonna be like this.
> 

I know we should allow multiple hierarchies, but why we allow this even
if sane_behavior is specified?

Like this:

# mount -t cgroup -o cpuset,__DEVEL__sane_behavior xxx /cgroup
# mount -t cgroup -o __DEVEL__sane_behavior xxx /cgroup2/


