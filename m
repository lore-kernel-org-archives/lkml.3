Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752154Ab3HABLd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 21:11:33 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:23705 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751975Ab3HABLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 21:11:31 -0400
Message-ID: <51F9B5BD.2070502@huawei.com>
Date: Thu, 1 Aug 2013 09:11:25 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH v2 5/5] cgroup: remove struct cgroup_seqfile_state
References: <51F8DA99.3010303@huawei.com> <20130731113619.GL2810@htj.dyndns.org>
In-Reply-To: <20130731113619.GL2810@htj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/7/31 19:36, Tejun Heo wrote:
> On Wed, Jul 31, 2013 at 05:36:25PM +0800, Li Zefan wrote:
>> We can use struct cfent instead.
>>
>> v2:
>> - remove cgroup_seqfile_release().
>>
>> Signed-off-by: Li Zefan <lizefan@huawei.com>
> 
> Applied to libata/for-3.12.
> 

libata? I hope you didn't. :)

