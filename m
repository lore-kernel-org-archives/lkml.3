Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751612AbaDUIMy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 04:12:54 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:49766 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902AbaDUIMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 04:12:51 -0400
Message-ID: <5354D422.8010606@linux.vnet.ibm.com>
Date: Mon, 21 Apr 2014 13:47:38 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: lizefan@huawei.com, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 12/12] cgroup: implement dynamic subtree controller enable/disable
 on the default hierarchy
References: <1397511430-2673-1-git-send-email-tj@kernel.org> <1397511430-2673-13-git-send-email-tj@kernel.org> <CAC4Lta0tD=FbtVpGnLw2sKMY69+AnqYqaOvCQdFs88JeR5Pemw@mail.gmail.com> <20140418204108.GL23576@htj.dyndns.org>
In-Reply-To: <20140418204108.GL23576@htj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042108-9264-0000-0000-000005E5D8A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/19/2014 02:11 AM, Tejun Heo wrote:
> Hello,
>
> On Thu, Apr 17, 2014 at 11:33:50PM +0530, Raghavendra KT wrote:
>> On Tue, Apr 15, 2014 at 3:07 AM, Tejun Heo <tj@kernel.org> wrote:
>> I undertsand that with the above parsing we could do
>> echo "-blkio +blkio" > cgroup.subtree_control and honor last enable/disable.
>
> Yeah, and the behavior is described in the following document.
>

Hello Tejun, Thanks for the kind reply. The document has helped me a
lot while reviewing,testing the unified hierarchy code.

>   http://lkml.kernel.org/g/20140416145248.GD1257@htj.dyndns.org
>
>> It confused me while testing. do you think we should return -EINVAL in
>> such case?
>
> Hmmm... I think whatever comes later wins is a pretty clear and easy
> rule, no?

Very much correct. and if there is a feeling to check multiple entry
later I would happy to update the code.

