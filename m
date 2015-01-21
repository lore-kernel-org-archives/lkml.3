Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753614AbbAUQvt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 11:51:49 -0500
Received: from mail-la0-f43.google.com ([209.85.215.43]:59195 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752198AbbAUQvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 11:51:41 -0500
MIME-Version: 1.0
In-Reply-To: <54BFCDA1.4060205@metafoo.de>
References: <1421855590-9210-1-git-send-email-ricardo.ribalda@gmail.com>
 <1421855590-9210-2-git-send-email-ricardo.ribalda@gmail.com> <54BFCDA1.4060205@metafoo.de>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Wed, 21 Jan 2015 17:51:19 +0100
Message-ID: <CAPybu_2UqrAQ+a=9Luni12uvN8hfa9DFW8vtfGp+UE_VcMX_hw@mail.gmail.com>
Subject: Re: [PATCH 1/3] spi/xilinx: Use automatic bus number on device tree
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Mark Brown <broonie@kernel.org>, Michal Simek <michal.simek@xilinx.com>,
        =?UTF-8?Q?S=C3=B6ren_Brinkmann?= <soren.brinkmann@xilinx.com>,
        linux-spi@vger.kernel.org,
        "moderated list:ARM/S5P EXYNOS AR..." 
	<linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lars

I think you are right. The other patches on the set are still valid though


Thanks!

On Wed, Jan 21, 2015 at 5:02 PM, Lars-Peter Clausen <lars@metafoo.de> wrote:
> On 01/21/2015 04:53 PM, Ricardo Ribalda Delgado wrote:
>>
>> If there is more than one spi device on a device tree, the second one
>> will fail to probe due to a duplicated bus_num.
>
>> [...]
>
> This should already be fixed. See commit 4b153a2137c5 ("spi: xilinx: Use
> pdev->id instead of pdev->dev.id for the SPI bus number")[1]. If the device
> was registered using devicetree pdev->id is -1, so dynamic numbers will be
> used.
>
> - Lars
>
> [1]
> http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/drivers/spi/spi-xilinx.c?id=4b153a2137c5d2914794c8944d78c731c1b0ae9d
>



-- 
Ricardo Ribalda
