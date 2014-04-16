Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751314AbaDPBbL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 21:31:11 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:13627 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102AbaDPBbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 21:31:08 -0400
Message-ID: <534DDD38.9090800@huawei.com>
Date: Wed, 16 Apr 2014 09:30:32 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <containers@lists.linux-foundation.org>, <cgroups@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <john@johnmccutchan.com>,
        <rlove@rlove.org>, <eparis@parisplace.org>,
        <gregkh@linuxfoundation.org>, <serge.hallyn@ubuntu.com>,
        <lennart@poettering.net>, <kay@vrfy.org>
Subject: Re: [PATCH 3/3] cgroup: implement cgroup.subtree_populated for the
 default hierarchy
References: <1397511846-2904-1-git-send-email-tj@kernel.org> <1397511846-2904-4-git-send-email-tj@kernel.org> <534C83F1.9020106@huawei.com> <20140415145450.GL1863@htj.dyndns.org> <20140415165221.GD30990@htj.dyndns.org>
In-Reply-To: <20140415165221.GD30990@htj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/4/16 0:52, Tejun Heo wrote:
> On Tue, Apr 15, 2014 at 10:54:50AM -0400, Tejun Heo wrote:
>> Hello,
>>
>> On Tue, Apr 15, 2014 at 08:57:21AM +0800, Li Zefan wrote:
>>> Is cgroup.tree_populated a better name?
>>>
>>> cgroup.subtree_control controls child cgroups only, but .subtree_populated
>>> shows 1 if there're tasks in the cgroup or its children, so the two
>>> are a bit inconsistent to me.
>>
>> Yes, good catch.  subtree_control affects subtree proper.
>> subtree_populated covers self too.  The difference is subtle and the
>> trade off between shared pattern in names and clarifying the subtlety
>> didn't seem clear-cut to me.  Hmmm....
> 
> How about cgroup.populated?
> 

Yeah, fine for me.

