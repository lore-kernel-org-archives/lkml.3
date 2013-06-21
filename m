Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946008Ab3FUUSk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 16:18:40 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:45840 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945950Ab3FUUSj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 16:18:39 -0400
MIME-Version: 1.0
In-Reply-To: <51C3E276.8030804@zytor.com>
References: <1371128589-8953-1-git-send-email-tangchen@cn.fujitsu.com>
	<51C3E276.8030804@zytor.com>
Date: Fri, 21 Jun 2013 13:18:38 -0700
X-Google-Sender-Auth: 5pgaw32BfK0pVMCryCN0o_rNhYM
Message-ID: <CAE9FiQUVeGyQuT8rBHnkm08o5vQZdH3-=zm6nfEkvRPnGhpnbg@mail.gmail.com>
Subject: Re: [Part1 PATCH v5 00/22] x86, ACPI, numa: Parse numa info earlier
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>, Tejun Heo <tj@kernel.org>
Cc: Tang Chen <tangchen@cn.fujitsu.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Renninger <trenn@suse.de>, Jiang Liu <jiang.liu@huawei.com>,
        Wen Congyang <wency@cn.fujitsu.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Minchan Kim <minchan@kernel.org>,
        mina86@mina86.com, gong.chen@linux.intel.com,
        Vasilis Liaskovitis <vasilis.liaskovitis@profitbricks.com>,
        lwoodman@redhat.com, Rik van Riel <riel@redhat.com>,
        jweiner@redhat.com, Prarit Bhargava <prarit@redhat.com>,
        "the arch/x86 maintainers" <x86@kernel.org>, linux-doc@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 20, 2013 at 10:19 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 06/13/2013 06:02 AM, Tang Chen wrote:
>> From: Yinghai Lu <yinghai@kernel.org>
>>
>> No offence, just rebase and resend the patches from Yinghai to help
>> to push this functionality faster.
>> Also improve the comments in the patches' log.
>>
>
> So we need a new version of this which addresses the build problems and
> the feedback from Tejun... and it would be good to get that soon, or
> we'll be looking at 3.12.
>
> Since the merge window is approaching quickly, is there a meaningful
> subset that is ready now?

patch 1-9, and 20 in updated patchset, could goto 3.11.
git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git
for-x86-mm
https://git.kernel.org/cgit/linux/kernel/git/yinghai/linux-yinghai.git/log/?h=for-x86-mm

they are about acpi_override move early and some enhancement.
they got enough tested-by and Acked-by include ones from tj.

If you are ok with that, I could resend those 10 patches today.

Thanks

Yinghai
