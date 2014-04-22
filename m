Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752729AbaDVGpL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 02:45:11 -0400
Received: from mail-ig0-f181.google.com ([209.85.213.181]:64579 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752125AbaDVGpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 02:45:07 -0400
MIME-Version: 1.0
In-Reply-To: <53560A9A.4020800@huawei.com>
References: <1398144449-9325-1-git-send-email-nasa4836@gmail.com> <53560A9A.4020800@huawei.com>
From: Jianyu Zhan <nasa4836@gmail.com>
Date: Tue, 22 Apr 2014 14:44:26 +0800
Message-ID: <CAHz2CGXz3VS6LYoES36h4T8Oe=XX-+b=N7TBFY1j9O3oLuq=gQ@mail.gmail.com>
Subject: Re: [PATCH] cgroup: explicitly init the early_init field
To: Li Zefan <lizefan@huawei.com>
Cc: Tejun Heo <tj@kernel.org>, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 2:22 PM, Li Zefan <lizefan@huawei.com> wrote:
> If you think this is the right thing to do, you can apply the same reason
> to the initialization of other structures in the whole kernel tree.
>
>> Signed-off-by: Jianyu Zhan <nasa4836@gmail.com>
>
> nack

Hi, Li,

Sorry for the noise.

For cpuset subsystem, this filed is nonzero; for other subsystems, this is zero.
Actually none of these subsystem will change this field,  I just
thought that  this is a little subtle. as the comment in patches says,
this is mainly for
document reason to inform other maintainers that css_alloc
implementation should be
taken care of , depending on this field is zero or not.


Thanks,
Jianyu Zhan
