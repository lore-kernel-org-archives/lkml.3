Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758751Ab3AQEip (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 23:38:45 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:16916 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758395Ab3AQEio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 23:38:44 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Wed, 16 Jan 2013 20:37:26 -0800
Message-ID: <50F78030.6080305@nvidia.com>
Date: Thu, 17 Jan 2013 10:08:08 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] ARM: tegra: config: enable SERIAL_TEGRA
References: <1358341572-8154-1-git-send-email-ldewangan@nvidia.com> <50F6EA0A.4080904@wwwdotorg.org>
In-Reply-To: <50F6EA0A.4080904@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 16 January 2013 11:27 PM, Stephen Warren wrote:
> On 01/16/2013 06:06 AM, Laxman Dewangan wrote:
>> Enable high speed serial driver for tegra platform.
> Thanks, I've applied patch 1 to Tegra's for-3.9/defconfig branch and
> patch 2 to Tegra's for-3.9/dt branch.
>
> Just as an FYI, the dt branch is merged into my for-next branch, and
> sent upstream, before the defconfig branch, so your patch order was
> reversed relative to that, but it's not an issue here.

Thanks for applying it. There is no issue on the reversing the sequence.


> Question: How do I test this; do I just fire up bluez(?) and point it at
> the UARTC serial port, or is there more to it?

I tested this in may pieces, not with the bluez.
I tested this in downstream with linux-next dma, this new serial driver, 
some hacks in the board files with bluetooth.

Then I tested this again on linux-next with some hacks in board-dt filew 
with invoking  the driver from cardhu dts file. In this I tested driver 
registration, basic write is wokring or not with some register 
dump/interrupt, Not checked data integrity as not connected the serial 
sniffer. The idea is that nothing should be crash in linux-next. The 
basic driver code is already tested with bluetooth.




