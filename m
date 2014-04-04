Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753279AbaDDGxU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 02:53:20 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:39030 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752050AbaDDGxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 02:53:17 -0400
Message-ID: <533E56D7.3060102@ti.com>
Date: Fri, 4 Apr 2014 09:53:11 +0300
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Nishanth Menon <nm@ti.com>, <mturquette@linaro.org>
CC: <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <ldewangan@nvidia.com>,
        <linux-doc@vger.kernel.org>, <grant.likely@linaro.org>
Subject: Re: [PATCH] clk: Add driver for Palmas clk32kg and clk32kgaudio clocks
References: <1396522348-31989-1-git-send-email-peter.ujfalusi@ti.com> <533D66F2.7050600@ti.com>
In-Reply-To: <533D66F2.7050600@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03/2014 04:49 PM, Nishanth Menon wrote:
> On 04/03/2014 05:52 AM, Peter Ujfalusi wrote:
> [...]
>>  .../devicetree/bindings/clock/clk-palmas.txt       |  35 +++
>>  drivers/clk/Kconfig                                |   7 +
>>  drivers/clk/Makefile                               |   1 +
>>  drivers/clk/clk-palmas.c                           | 307 +++++++++++++++++++++
>>  include/dt-bindings/mfd/palmas.h                   |  18 ++
>>  5 files changed, 368 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/clock/clk-palmas.txt
>>  create mode 100644 drivers/clk/clk-palmas.c
>>  create mode 100644 include/dt-bindings/mfd/palmas.h
> 
> 
> Only complaint i have is based on :
> http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=2a9330010bea5982a5c6593824bc036bf62d67b7

Oh, I see.
I'll wait for comments and resend as a series. Probably it is going to be
better if I rename the documentation file as well to
bindings/clock/ti,palmas-clk.txt
I think having two separate document for the two clock is overkill.

> you may want to split the new binding off to a separate patch.
> Otherwise, personally, I think it is an good evolution, thanks for
> doing it.
> 
> 


-- 
Péter
