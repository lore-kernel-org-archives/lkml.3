Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755776AbaKSRHr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 12:07:47 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:53389 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753980AbaKSRHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 12:07:46 -0500
Message-ID: <546CCE73.4020708@wwwdotorg.org>
Date: Wed, 19 Nov 2014 10:08:03 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Lee Jones <lee@kernel.org>, Matthias Klein <matthias.klein@linux.com>
CC: linux-rpi-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ARM: bcm2835: add device tree for Raspberry Pi model
 B+
References: <1415231123-920-1-git-send-email-matthias.klein@linux.com> <20141119152951.GA1875@x1>
In-Reply-To: <20141119152951.GA1875@x1>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/19/2014 08:29 AM, Lee Jones wrote:
>> The model B and B+ differ in the GPIO lines for ACT and PWR leds, and the
>> I2S interface.
>>
>> Signed-off-by: Matthias Klein <matthias.klein@linux.com>
>> ---
>> Changes in v2:
>> - move the common parts between the B and B+ model into the new bcm2835-rpi.dtsi file
>>
>> - add the I2S signals to the B+ file which fix the problem that USB is not working
>>    with the current bcm2835-rpi-b.dts file on the B+.
>> ---
>>   arch/arm/boot/dts/Makefile               |  1 +
>>   arch/arm/boot/dts/bcm2835-rpi-b-plus.dts | 30 +++++++++++++++++++
>>   arch/arm/boot/dts/bcm2835-rpi-b.dts      | 46 ++--------------------------
>>   arch/arm/boot/dts/bcm2835-rpi.dtsi       | 51 ++++++++++++++++++++++++++++++++
>>   4 files changed, 85 insertions(+), 43 deletions(-)
>>   create mode 100644 arch/arm/boot/dts/bcm2835-rpi-b-plus.dts
>>   create mode 100644 arch/arm/boot/dts/bcm2835-rpi.dtsi
>
> Sorry for the delay.  I thought RPi world was exceptionally quiet, but
> in fact I had issues with my newly setup mailbox and filters.  All
> rectified now in any case.
>
> It might be worth noting that this will not likely land in v3.19, as
> we are one step removed from Linus (i.e. via ARM SoC) and they usually
> like to have pull-requests in by -rc5.  Unless anyone stamps their
> feet, I'll be sending this no sooner than v3.20.

-rc6 is the usual cut-off, and the arm-soc maintainers have said that's 
not always a very strict cut-off; it depends on how invasive the patch 
is (which this isn't) and whether the patch has been in linux-next 
already before getting into arm-soc (and linux-rpi.git's for-next branch 
is in linux-next).
