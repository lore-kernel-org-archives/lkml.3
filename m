Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932228AbaFIKOx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 06:14:53 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:52799 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754188AbaFIKOv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 06:14:51 -0400
Message-ID: <53958913.8080708@gmail.com>
Date: Mon, 09 Jun 2014 12:14:43 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
To: Peter Chen <peter.chen@freescale.com>,
        =?ISO-8859-1?Q?Antoine_T=E9n?= =?ISO-8859-1?Q?art?= 
	<antoine.tenart@free-electrons.com>
CC: balbi@ti.com, p.zabel@pengutronix.de, alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/9] ARM: Berlin: USB support
References: <1401983326-19205-1-git-send-email-antoine.tenart@free-electrons.com> <20140609043019.GA32255@shlinux1.ap.freescale.net>
In-Reply-To: <20140609043019.GA32255@shlinux1.ap.freescale.net>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/09/2014 06:30 AM, Peter Chen wrote:
> On Thu, Jun 05, 2014 at 05:48:37PM +0200, Antoine Ténart wrote:
>> This series adds the support for the Marvell Berlin USB controllers,
>> the USB PHYs and also adds a reset controller.
>>
>> The reset controller is used by the USB PHY driver and shares the
>> existing chip controller node with the clocks and one pin controller.
>>
>> The Marvell Berlin USB controllers are host only on the BG2Q and are
>> compatible with USB ChipIdea. We here add a glue to use the available
>> common functions for this kind of controllers. A USB PHY driver is also
>> added to control the PHY.
[...]
> 
> I am fine with 6/9, 7/9, will queue them if no other objections.
> 

Thanks Peter,

we are early in the cycle and I feel there will be a v2 of the
chipidea stub. IMHO, controlling the vbus regulator should not
be business of the phy driver, so ci will have to deal with it.

Anyways, good to know you are fine with it already!

Sebastian
