Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753239Ab3KGNkz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 08:40:55 -0500
Received: from mail-ea0-f178.google.com ([209.85.215.178]:51338 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956Ab3KGNkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 08:40:52 -0500
Message-ID: <527B9861.1020606@linaro.org>
Date: Thu, 07 Nov 2013 14:40:49 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Simon Horman <horms@verge.net.au>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
CC: linux-arm-kernel@lists.infradead.org, linux-sh@vger.kernel.org,
        Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] clocksource: sh_tmu: Add clk_prepare/unprepare
 support
References: <1383000569-8916-4-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <1383057097-22689-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <1383057097-22689-2-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <20131031052406.GN1603@verge.net.au>
In-Reply-To: <20131031052406.GN1603@verge.net.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/31/2013 06:24 AM, Simon Horman wrote:
> On Tue, Oct 29, 2013 at 03:31:37PM +0100, Laurent Pinchart wrote:
>> Prepare the clock at probe time, as there is no other appropriate place
>> in the driver where we're allowed to sleep.
>>
>> Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
>> Cc: linux-kernel@vger.kernel.org
>> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
>
> Thanks, I have queued this up.

Ok, so those patches go through your tree, right ?

I have been out for the Linaro connect but I saw you picked them. In the 
future, I would prefer to take them in my tree as they fall under the 
drivers/clocksource maintainer's umbrella.

Thanks
   -- Daniel

-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

