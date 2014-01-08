Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757582AbaAHWlO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 17:41:14 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:50397 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757504AbaAHWlL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 17:41:11 -0500
Message-ID: <52CDD3FE.1070404@wwwdotorg.org>
Date: Wed, 08 Jan 2014 15:41:02 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Andrew Bresticker <abrestic@chromium.org>,
        Mike Turquette <mturquette@linaro.org>
CC: Thierry Reding <thierry.reding@gmail.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>, linux-tegra@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 0/7] misc Tegra clock fixes
References: <1388105067-24438-1-git-send-email-abrestic@chromium.org> <CAL1qeaG0Y4__viWsZeoFdf8XFN3Wk7CO2abeEjzRZg+wNRV56w@mail.gmail.com>
In-Reply-To: <CAL1qeaG0Y4__viWsZeoFdf8XFN3Wk7CO2abeEjzRZg+wNRV56w@mail.gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08/2014 03:28 PM, Andrew Bresticker wrote:
> Hi Stephen, Peter,
> 
>> Fixes for various clock-related issues found during bringup of
>> Tegra124-based Venice2 and Norrin boards.
...
> Any comments on this series?

Peter owns drivers/clk/tegra/, so I assume he'll handle these patches. I
briefly looked at them when they were posted and didn't see any issues.

