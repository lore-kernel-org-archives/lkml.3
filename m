Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752666AbaDVHxR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 03:53:17 -0400
Received: from mail-ig0-f182.google.com ([209.85.213.182]:54019 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752031AbaDVHxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 03:53:14 -0400
MIME-Version: 1.0
In-Reply-To: <53560BA3.40501@huawei.com>
References: <1398145479-11400-1-git-send-email-nasa4836@gmail.com> <53560BA3.40501@huawei.com>
From: Jianyu Zhan <nasa4836@gmail.com>
Date: Tue, 22 Apr 2014 15:52:34 +0800
Message-ID: <CAHz2CGU53gq_ouB-0M9bOJjW0FWHSzeT3ju8Y7oMsnsQJjXLWA@mail.gmail.com>
Subject: Re: [PATCH] cgroup: use uninitialized_var() for may-be uninitialized variable
To: Li Zefan <lizefan@huawei.com>
Cc: Tejun Heo <tj@kernel.org>, containers@lists.linux-foundation.org,
        Cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Li,


On Tue, Apr 22, 2014 at 2:26 PM, Li Zefan <lizefan@huawei.com> wrote:
>
> I don't see this warning, and I don't see how this is possible.

You are right.  No such warning.
It is triggered by the other patch, should be fixed in that patch.



Thanks,
Jianyu Zhan
