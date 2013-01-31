Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841Ab3AaCPl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 21:15:41 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:65362 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365Ab3AaCPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 21:15:39 -0500
Message-ID: <5109D3B6.9060905@huawei.com>
Date: Thu, 31 Jan 2013 10:15:18 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Aristeu Rozanski <aris@redhat.com>, "Serge E. Hallyn" <serge@hallyn.com>,
        <linux-kernel@vger.kernel.org>, <cgroups@vger.kernel.org>,
        Serge Hallyn <serge.hallyn@canonical.com>
Subject: Re: [PATCH v4 8/9] devcg: refactor dev_exception_clean()
References: <20130130171101.060853036@napanee.usersys.redhat.com> <20130130171102.253395279@napanee.usersys.redhat.com> <20130130204730.GF8507@mail.hallyn.com> <20130130204917.GL17632@redhat.com> <CAOS58YOHkK9xTBPFAXKksrwP7ZxQc_WuGOp39D94Z1pBsFHfjw@mail.gmail.com>
In-Reply-To: <CAOS58YOHkK9xTBPFAXKksrwP7ZxQc_WuGOp39D94Z1pBsFHfjw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/1/31 4:50, Tejun Heo wrote:
> Hello,
> 
> On Wed, Jan 30, 2013 at 12:49 PM, Aristeu Rozanski > that's not
> intentional. thanks for catching this
>>
>> Tejun, you want me to resubmit the whole series or just the next patch
>> (where I was supposed to move that chunk)?
> 
> If it doesn't affect the next patch, just posting an updated version
> of this patch should be enough, I think. Which tree are these patches
> planned to go through?
> 

It used to be -mm tree, but I bet Andrew would be happy to see you
route them through your tree. ;)

