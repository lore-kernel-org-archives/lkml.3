Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932647Ab3B1Oty (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 09:49:54 -0500
Received: from mail-qa0-f47.google.com ([209.85.216.47]:35376 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932619Ab3B1Otr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 09:49:47 -0500
MIME-Version: 1.0
In-Reply-To: <512EFEDF.8080205@huawei.com>
References: <512B01FA.5020506@huawei.com>
	<512B020D.9040504@huawei.com>
	<20130226022703.GA13837@htj.dyndns.org>
	<512C8D84.7090707@huawei.com>
	<CAOS58YMb7HRQ3X+Z92vi3+jKr4DuNmAgxtc5e3Jkhy-s-7Os-g@mail.gmail.com>
	<512DE4A8.5050303@huawei.com>
	<CAOS58YMhm6Uia0bx6oUHwheXUhu8i31LPhh8VVggvg0vg-UmUQ@mail.gmail.com>
	<512EFEDF.8080205@huawei.com>
Date: Thu, 28 Feb 2013 06:49:46 -0800
X-Google-Sender-Auth: nIysSEKY_dramGUnL_3JJWn6lw8
Message-ID: <CAOS58YMBcvhfBWdQmt=JersRgB9nVgsrLACtLovz===2ZXfR=w@mail.gmail.com>
Subject: Re: [PATCH 2/3] cgroup: add cgroup_name() API
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 27, 2013 at 10:53 PM, Li Zefan <lizefan@huawei.com> wrote:
>> static const struct cgroup_name root_cgroup_name = { .name = "/" };
>
> Can't... That's char name[0] not char *name.

Flexible array members can be statically initialized. If you wanna be
really anal about it, you can do it manually with a wrapping struct
but I don't think that would be necessary.

Thanks.

-- 
tejun
