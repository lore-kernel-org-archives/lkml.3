Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755213Ab3BJOC0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2013 09:02:26 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:18093 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754970Ab3BJOCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2013 09:02:24 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Sun, 10 Feb 2013 06:02:23 -0800
Message-ID: <5117A904.4040309@nvidia.com>
Date: Sun, 10 Feb 2013 23:04:52 +0900
From: Alex Courbot <acourbot@nvidia.com>
Organization: NVIDIA
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130109 Thunderbird/17.0.2
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        <gnurou@gmail.com>
Subject: Re: [grant:gpio/next 10/16] gpiolib.c:undefined reference to `gpiod_unexport'
References: <51166e1c.NRfQN8VgI14zuNwf%fengguang.wu@intel.com> <CACxGe6tAEX7o9dxNTXtwKwzZHmEteKAS+7uy4j-DTX_2V583tg@mail.gmail.com>
In-Reply-To: <CACxGe6tAEX7o9dxNTXtwKwzZHmEteKAS+7uy4j-DTX_2V583tg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

On 02/10/2013 01:34 AM, Grant Likely wrote:
 > Alex, this is broken when the sysfs interface isn't enabled. Can you
 > send a fixup patch?
 >
 > g.
 >
 > On Sat, Feb 9, 2013 at 3:41 PM, kbuild test robot
 > <fengguang.wu@intel.com> wrote:
 >> tree:   git://git.secretlab.ca/git/linux-2.6.git gpio/next
 >> head:   8a307b35962e42de0f998c6029e8851c61eadb4e
 >> commit: 5bb47609e8167d733786cb781ada29536385635c [10/16] gpiolib: 
use descriptors internally
 >> config: i386-randconfig-b040 (attached as .config)
 >>
 >> All error/warnings:
 >>
 >>     drivers/built-in.o: In function `gpiod_free':
 >>>> gpiolib.c:(.text+0xda3): undefined reference to `gpiod_unexport'
 >>     drivers/built-in.o: In function `gpio_request_one':
 >>>> (.text+0x147f): undefined reference to `gpiod_export'

Sorry about that. I have sent you the fix in a separate mail. Please 
meld it into the culprit commit to fix this.

Thanks,
Alex.
