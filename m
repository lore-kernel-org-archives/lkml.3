Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965822Ab3E2Lap (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 07:30:45 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:15251 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965495Ab3E2Lao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 07:30:44 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 29 May 2013 04:30:43 -0700
Message-ID: <51A5E67C.8020002@nvidia.com>
Date: Wed, 29 May 2013 14:29:00 +0300
From: Arto Merilainen <amerilainen@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Thierry Reding <thierry@gilfi.de>
CC: "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "airlied@linux.ie" <airlied@linux.ie>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Terje Bergstrom <tbergstrom@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2 3/7] gpu: host1x: Don't reset firewall between gathers
References: <1369823168-5396-1-git-send-email-amerilainen@nvidia.com> <1369823168-5396-4-git-send-email-amerilainen@nvidia.com> <20130529112127.GA8079@manwe>
In-Reply-To: <20130529112127.GA8079@manwe>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/29/2013 02:21 PM, Thierry Reding wrote:
> * PGP Signed by an unknown key
>
> * Arto Merilainen wrote:
> [...]
>> diff --git a/drivers/gpu/host1x/job.c b/drivers/gpu/host1x/job.c
> [...]
>> @@ -553,7 +549,6 @@ int host1x_job_pin(struct host1x_job *job, struct device *dev)
>>
>>   		if (!err)
>>   			err = do_waitchks(job, host, g->bo);
>> -
>>   		if (err)
>>   			break;
>>   	}
>
> This is another unnecessary whitespace change, but since it was the only
> issue I saw with the series I fixed it up myself while applying.
>

Thanks! I thought I got them all before posting but apparently not...

- Arto

