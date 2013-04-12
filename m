Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753821Ab3DLTYX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 15:24:23 -0400
Received: from mail-bk0-f45.google.com ([209.85.214.45]:62928 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752680Ab3DLTYV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 15:24:21 -0400
Message-ID: <51685F60.9010802@gmail.com>
Date: Fri, 12 Apr 2013 21:24:16 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>
CC: Michal Bachraty <michal.bachraty@streamunlimited.com>,
        grant.likely@secretlab.ca, rob.herring@calxeda.com, rob@landley.net,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] clk: si5351: Add gapless tuning for SI5351 PLL
References: <1365495975-792-1-git-send-email-michal.bachraty@streamunlimited.com> <20130412183809.6507.27844@quantum>
In-Reply-To: <20130412183809.6507.27844@quantum>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12/2013 08:38 PM, Mike Turquette wrote:
> Quoting Michal Bachraty (2013-04-09 01:26:15)
>> For gapless tuning, there is no need for PLL reset and clkout power-down
>> when tuning output. "silabs,gapless-tuning" parameter enables gapless tuning
>> for specific clock output.
>>
>> Signed-off-by: Michal Bachraty<michal.bachraty@streamunlimited.com>
>
> Hi Michal,
>
> This did not apply cleanly on the latest (v8) si5351 clk driver.  Can
> you refresh it?  I do not plan on taking any more patches for 3.10 after
> 3.9-rc7 drops (likely on Sunday or Monday).  So this patch may need to
> wait until after the merge window.

Mike,

I have integrated the above function into clk-si5351 during development
(see clk-si5351 changelog from v6->v7). I think we can drop this patch,
as Michal added his Tested-by to clk-si5351.

Regards,
   Sebastian
