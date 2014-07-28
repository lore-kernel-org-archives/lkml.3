Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751381AbaG1Gb1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 02:31:27 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:57841 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902AbaG1GbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 02:31:25 -0400
Message-ID: <53D5EE21.1040000@ti.com>
Date: Mon, 28 Jul 2014 12:00:57 +0530
From: Lokesh Vutla <lokeshvutla@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Keerthy <j-keerthy@ti.com>, <linux-patch-review@list.ti.com>
CC: <nm@ti.com>, <mark.rutland@arm.com>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <tony@atomide.com>, <galak@codeaurora.org>
Subject: Re: [PATCH 0/2] ARM: dts: dra72-evm: Add i2c1 and tps65917 nodes
References: <1406528334-4415-1-git-send-email-j-keerthy@ti.com>
In-Reply-To: <1406528334-4415-1-git-send-email-j-keerthy@ti.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 28 July 2014 11:48 AM, Keerthy wrote:
> The patch series adds i2c1 and tps65917 and related nodes.
> The patch series is boot tested on DRA72-EVM.
> 
> Thanks to Lokesh <lokeshvutla@ti.com> for testing the series.
For booting, this is dependent on recent hwmod fix patch series posted by me:
http://www.mail-archive.com/linux-omap@vger.kernel.org/msg108001.html

Boot log for this series can be found here:
http://paste.ubuntu.com/7881545/

Thanks and regards,
Lokesh
> 
> Keerthy J (2):
>   ARM: dts: dra72-evm: Enable I2C1 node
>   ARM: dts: dra72-evm: Add tps65917 PMIC node
> 
>  arch/arm/boot/dts/dra72-evm.dts |  120 +++++++++++++++++++++++++++++++++++++++
>  1 file changed, 120 insertions(+)
> 

