Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752965Ab3JBFon (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 01:44:43 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:2712 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752101Ab3JBFol (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 01:44:41 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 01 Oct 2013 22:44:40 -0700
Message-ID: <524BB1E5.9080601@nvidia.com>
Date: Wed, 2 Oct 2013 08:40:53 +0300
From: Arto Merilainen <amerilainen@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Terje Bergstrom <tbergstrom@nvidia.com>,
        Thierry Reding <treding@nvidia.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mayuresh Kulkarni <mkulkarni@nvidia.com>
Subject: Re: [PATCHv3 4/4] gpu: host1x: Add runtime pm support for host1x
References: <1380024325-18280-1-git-send-email-amerilainen@nvidia.com> <1380024325-18280-5-git-send-email-amerilainen@nvidia.com> <524B11AA.30400@wwwdotorg.org>
In-Reply-To: <524B11AA.30400@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01/2013 09:17 PM, Stephen Warren wrote:
> On 09/24/2013 06:05 AM, Arto Merilainen wrote:
>> From: Mayuresh Kulkarni <mkulkarni@nvidia.com>
>>
>> This patch adds runtime pm support for host1x hardware unit. This
>> allows host1x clock to be turned off when it is idle. If pm runtime
>> is not configured, we enable host1x clock in device probe and disable
>> it in remove.
>
>> diff --git a/drivers/gpu/host1x/dev.c b/drivers/gpu/host1x/dev.c
>
>> +static int host1x_runtime_suspend(struct device *dev);
>> +static int host1x_runtime_resume(struct device *dev);
>
> You could avoid having these prototypes by simply putting the function
> bodies earlier on in the file, somewhere before they're used. I don't
> care much either way, but I've certainly seen some people care about
> this and ask for them to be moved.

Will fix.

- Arto

