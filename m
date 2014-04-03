Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752366AbaDCNtp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 09:49:45 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:39411 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752233AbaDCNtl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 09:49:41 -0400
Message-ID: <533D66F2.7050600@ti.com>
Date: Thu, 3 Apr 2014 08:49:38 -0500
From: Nishanth Menon <nm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Peter Ujfalusi <peter.ujfalusi@ti.com>, <mturquette@linaro.org>
CC: <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <ldewangan@nvidia.com>,
        <linux-doc@vger.kernel.org>, <grant.likely@linaro.org>
Subject: Re: [PATCH] clk: Add driver for Palmas clk32kg and clk32kgaudio clocks
References: <1396522348-31989-1-git-send-email-peter.ujfalusi@ti.com>
In-Reply-To: <1396522348-31989-1-git-send-email-peter.ujfalusi@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03/2014 05:52 AM, Peter Ujfalusi wrote:
[...]
>  .../devicetree/bindings/clock/clk-palmas.txt       |  35 +++
>  drivers/clk/Kconfig                                |   7 +
>  drivers/clk/Makefile                               |   1 +
>  drivers/clk/clk-palmas.c                           | 307 +++++++++++++++++++++
>  include/dt-bindings/mfd/palmas.h                   |  18 ++
>  5 files changed, 368 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/clock/clk-palmas.txt
>  create mode 100644 drivers/clk/clk-palmas.c
>  create mode 100644 include/dt-bindings/mfd/palmas.h


Only complaint i have is based on :
http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=2a9330010bea5982a5c6593824bc036bf62d67b7

you may want to split the new binding off to a separate patch.
Otherwise, personally, I think it is an good evolution, thanks for
doing it.


-- 
Regards,
Nishanth Menon
