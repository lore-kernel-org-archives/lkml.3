Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417AbaHUNtw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 09:49:52 -0400
Received: from mail-ig0-f179.google.com ([209.85.213.179]:36538 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754551AbaHUNtt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 09:49:49 -0400
MIME-Version: 1.0
In-Reply-To: <53F5F7BF.6040809@ti.com>
References: <1408381015-16042-1-git-send-email-nm@ti.com>
	<53F5F7BF.6040809@ti.com>
Date: Thu, 21 Aug 2014 08:49:49 -0500
X-Google-Sender-Auth: hYUnwcBvNQZI039TwnAVOORHGtE
Message-ID: <CAGo_u6onBbuNC9sLvBE5nFA7wMLkrsmbS3k2rgR1o6f1bYWvdg@mail.gmail.com>
Subject: Re: [PATCH 0/2] clk: ti: Fix up error checks in set_rate (and div 0 error)
From: Nishanth Menon <nm@ti.com>
To: Tero Kristo <t-kristo@ti.com>
Cc: Mike Turquette <mturquette@linaro.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 21, 2014 at 8:44 AM, Tero Kristo <t-kristo@ti.com> wrote:
> On 08/18/2014 07:56 PM, Nishanth Menon wrote:
>>
>> Hi,
>> The following patches are based on v3.17-rc1
>> Prior to this series: http://slexy.org/view/s20QH6PW4x (notice the /0 div
>> error spam at initial boot log)
>> After this series: http://slexy.org/view/s20tPNXPf4
>
>
> Yeah, valid findings. However, you did not root-cause the problem, just
> added a bandaid for the most obvious errors.

Yep, it does seem that omap3_noncore_dpll_set_rate had the same
bandaid as well :).. but checks did make sense..

> I will queue these patches for 3.17-rc fixes anyway, but will post an actual fix in a bit.

Thanks for rootcausing.

---
Regards,
Nishanth Menon
