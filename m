Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755234AbaHUNoz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 09:44:55 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:44248 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755084AbaHUNox (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 09:44:53 -0400
Message-ID: <53F5F7BF.6040809@ti.com>
Date: Thu, 21 Aug 2014 16:44:31 +0300
From: Tero Kristo <t-kristo@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Nishanth Menon <nm@ti.com>, Mike Turquette <mturquette@linaro.org>
CC: <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 0/2] clk: ti: Fix up error checks in set_rate (and div
 0 error)
References: <1408381015-16042-1-git-send-email-nm@ti.com>
In-Reply-To: <1408381015-16042-1-git-send-email-nm@ti.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/18/2014 07:56 PM, Nishanth Menon wrote:
> Hi,
> The following patches are based on v3.17-rc1
> Prior to this series: http://slexy.org/view/s20QH6PW4x (notice the /0 div error spam at initial boot log)
> After this series: http://slexy.org/view/s20tPNXPf4

Yeah, valid findings. However, you did not root-cause the problem, just 
added a bandaid for the most obvious errors. I will queue these patches 
for 3.17-rc fixes anyway, but will post an actual fix in a bit.

-Tero

>
> Nishanth Menon (2):
>    clk: ti: divider: Provide error check for incoming parameters in
>      set_rate
>    clk: ti: dra7-atl: Provide error check for incoming parameters in
>      set_rate
>
>   drivers/clk/ti/clk-dra7-atl.c |    6 +++++-
>   drivers/clk/ti/divider.c      |    7 ++++++-
>   2 files changed, 11 insertions(+), 2 deletions(-)
>

