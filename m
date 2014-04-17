Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754219AbaDQNqK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 09:46:10 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:50686 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757182AbaDQNpl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 09:45:41 -0400
Message-ID: <534FDB04.6050406@gopivotal.com>
Date: Thu, 17 Apr 2014 14:45:40 +0100
From: Glyn Normington <gnormington@gopivotal.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] control groups: documentation improvements
References: <20140310142014.GC25290@htj.dyndns.org> <5321D6FA.4040500@gopivotal.com> <53225C69.3010202@huawei.com> <53230475.5050805@gopivotal.com> <20140314140136.GF12613@htj.dyndns.org> <53230C7E.7060607@gopivotal.com> <533C05D8.8020600@gopivotal.com> <533C0DD9.1050809@gopivotal.com> <20140416210025.GE26632@htj.dyndns.org> <534FB0F5.3010904@gopivotal.com> <20140417131615.GH26632@htj.dyndns.org>
In-Reply-To: <20140417131615.GH26632@htj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun

On 17/04/2014 14:16, Tejun Heo wrote:
> Hello, Glyn.
>
> On Thu, Apr 17, 2014 at 11:46:13AM +0100, Glyn Normington wrote:
>> +There may be zero or more active hierarchies. Each hierarchy has an
>> +instance of the cgroup virtual filesystem associated with it. The tree
>> +of cgroups is represented by the directory tree in the cgroup virtual
>> +filesystem.
>> +
>> +The sets of subsystems participating in distinct hierarchies are either
>> +identical or disjoint. If the sets are identical, the virtual filesystems
>> +associated with the hierarchies have identical content and a change in
>> +one is automatically reflected in all the others.
> I can't say I'm a big fan of these definitions in mathematical terms.
> They're so precise and useless at the same time.
We would like to be both precise and readable. Please point out the 
"useless" bits and we'll try to make them better.
> That said, I don't
> really understand the last paragraph.  Is it trying to talk about
> multiple mounts of a single hierarchy?
Yes. When this came up earlier, Li Zefan thought we could delete that 
paragraph "because we all know the same filesystem can have more than 
one mount point and cgroupfs is no different". But since the underlying 
cgroupfs is only visible through the representation(s) at its mount 
points, we'd prefer to keep the paragraph.

How about changing the  paragraph to say:

A given hierarchy may be associated with more than one virtual 
filesystem, in which case each of the virtual filesystems has identical 
contents to the others.

?
>
> Thanks.
Regards,
Glyn
