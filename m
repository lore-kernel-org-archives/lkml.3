Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751031AbaAXE5h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 23:57:37 -0500
Received: from mail-oa0-f42.google.com ([209.85.219.42]:51410 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767AbaAXE5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 23:57:34 -0500
MIME-Version: 1.0
In-Reply-To: <52E1C8BD.2010500@huawei.com>
References: <8622e93b9c49c66ffdc9ef0aa8371c322718edd5.1390475530.git.viresh.kumar@linaro.org>
	<alpine.DEB.2.02.1401231330530.7313@chino.kir.corp.google.com>
	<52E1C8BD.2010500@huawei.com>
Date: Fri, 24 Jan 2014 10:27:34 +0530
Message-ID: <CAKohpomn_wgQExfhJL6=MB9LrRhR4=+7t3ehy0d6vEq9duzr8Q@mail.gmail.com>
Subject: Re: [PATCH] cpusets: Allocate heap only when required
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Li Zefan <lizefan@huawei.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>, Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24 January 2014 07:28, Li Zefan <lizefan@huawei.com> wrote:
>> Acked-by: David Rientjes <rientjes@google.com>
>
> Acked-by: Li Zefan <lizefan@huawei.com>

Thanks..

> I would like this patch be picked up by Tejun. I'll send out a patchset
> for cpuset which may have confliction with this one.

Its already applied by Andrew Morton..
