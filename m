Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757634AbaEPQFY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 12:05:24 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:45263 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757064AbaEPQFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 12:05:22 -0400
Message-ID: <5376373E.1080401@wwwdotorg.org>
Date: Fri, 16 May 2014 10:05:18 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>,
        Tuomas Tynkkynen <ttynkkynen@nvidia.com>
CC: Mike Turquette <mturquette@linaro.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH] clk: tegra: Fix wrong value written to PLLE_AUX
References: <1400248220-16025-1-git-send-email-ttynkkynen@nvidia.com> <20140516143110.GA28338@ulmo>
In-Reply-To: <20140516143110.GA28338@ulmo>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/16/2014 08:31 AM, Thierry Reding wrote:
> On Fri, May 16, 2014 at 04:50:20PM +0300, Tuomas Tynkkynen wrote:
>> The value written to PLLE_AUX was incorrect due to a wrong variable
>> being used.
>>
>> Signed-off-by: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
>> Tested-by: Mikko Perttunen <mperttunen@nvidia.com>
>> ---
>>   This fix is required for the (upcoming) SATA support.
>>  drivers/clk/tegra/clk-pll.c |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Reviewed-by: Thierry Reding <treding@nvidia.com>
> Tested-by: Thierry Reding <treding@nvidia.com>
> Acked-by: Thierry Reding <treding@nvidia.com>
> 
> Mike, Peter, it might be good to have this go into 3.16 as a
> prerequisite for the upcoming SATA driver (which presumably won't be
> ready until 3.17, but in that case it would be good to have this
> prerequisite merged already).

Probably even Cc: stable since it's a fix for a bug that I assume has
been in a kernel release or two?
