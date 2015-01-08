Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756345AbbAHLXy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 06:23:54 -0500
Received: from mail-la0-f47.google.com ([209.85.215.47]:46641 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756008AbbAHLXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 06:23:52 -0500
Message-ID: <54AE68BC.305@gmail.com>
Date: Thu, 08 Jan 2015 14:23:40 +0300
From: Dmitry Osipenko <digetx@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>
CC: Paul Walmsley <paul@pwsan.com>, linux-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        Kumar Gala <galak@codeaurora.org>,
        Paul Walmsley <pwalmsley@nvidia.com>,
        Thierry Reding <treding@nvidia.com>, Allen Martin <amartin@nvidia.com>,
        Stephen Warren <swarren@nvidia.com>,
        Alexandre Courbot <gnurou@gmail.com>
Subject: Re: [PATCH] soc: tegra: pmc: restrict compilation of suspend-related
 support to ARM
References: <alpine.DEB.2.02.1412092224050.31750@utopia.booyaka.com> <20150107143354.GD1621@ulmo> <54AD4FB7.20600@gmail.com> <20150108084929.GA1987@ulmo.nvidia.com> <54AE5117.5020905@gmail.com> <20150108105818.GJ1987@ulmo.nvidia.com>
In-Reply-To: <20150108105818.GJ1987@ulmo.nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

08.01.2015 13:58, Thierry Reding пишет:
> On Thu, Jan 08, 2015 at 12:42:47PM +0300, Dmitry Osipenko wrote:
>> 08.01.2015 11:49, Thierry Reding пишет:
>>> I don't like changing this back to syscore_ops since it makes things
>>> less easier to follow. I also don't think that using PMC_SCRATCH41 for
>>> two different purposes is a good thing. There are a couple of
>>> suggestions in my reply to your original patch. Could you investigate
>>> whether any of those can be used to fix this instead?
>>>
>>> Thierry
>>>
>>
>> I haven't received your reply. Double checked gmail inbox and mailing lists -
>> nothing. It may just not propagated yet if you sent it today, otherwise can you
>> please re-send it?
> 
> For some reason it hadn't gone out. Should be now, though.
> 
> Thierry
> 

Received now, thanks! Your proposal sounds interesting, I'll try it.

-- 
Dmitry
