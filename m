Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753818AbaJCPHL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 11:07:11 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:36527 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753329AbaJCPHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 11:07:05 -0400
Message-ID: <542EBB93.108@gmail.com>
Date: Fri, 03 Oct 2014 17:06:59 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
To: Jason Cooper <jason@lakedaemon.net>, Benoit Masson <benoitm@perenite.com>
CC: Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Benoit Masson <yahoo@perenite.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/8] Armada XP pinctrl consolidation and ix4-300d fixes
References: <1411157684-6991-1-git-send-email-sebastian.hesselbarth@gmail.com> <-7443282711873112734@unknownmsgid> <20141003141102.GJ3895@titan.lakedaemon.net>
In-Reply-To: <20141003141102.GJ3895@titan.lakedaemon.net>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/03/2014 04:11 PM, Jason Cooper wrote:
> On Sun, Sep 21, 2014 at 04:11:23PM +0200, Benoit Masson wrote:
>>> Le 19 sept. 2014 à 22:14, Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com> a écrit :
>>> this is a patch set preparing barebox support for ix4-300d. As usual,
>>> I stumbled upon a few nice-to-haves before actually touching ix4-300d
>>> dts. As it is a mach-mvebu thing, I just added the related mailing
>>> lists instead of each of the DT maintainers.
>>>
>>> First 5 patches consolidate SoC-specific pinctrl nodes to one common
>>> node in armada-xp.dtsi, compatible overwrites for each SoC, and node
>>> alias usage for each board. Also, ge{0,1} pinctrl settings are moved
>>> to the common node from one board specific node.
>>>
>>> Last 3 patches then use that ge{0,1} pinctrl settings on ix4-300d which
>>> is vital for bootloader init. During exploration of ix4-300d, I also
>>> found a i2c eeprom that has not been added to the dts, yet. Finally,
>>> there is only one 74hc595 on ix4 mainboard while dts property is set
>>> for two.
>>>
>>> I cannot recall in detail what is on that eeprom, but IIRC it is nothing
>>> important. Some reg,addr pairs for some init stuff that should have
>>> already been done by stock u-boot. Anyway, adding the node will do no
>>> harm.
>>>
>>> Patches are based on v3.17-rc1 and intended for v3.18 but I am not in
>>> a hurry. I only compile tested this, so a formal Tested-by from Benoit
>>> for the ix4 and any other Armada XP board would be great.
>>
>> I'm not sure what to test since I only receive some patch from the
>> series of 8. Should I get all 8 or only those you sent me. I'll be
>> able to test during next week.
>
> Did you ever get a chance to test this series?

Uhm, I never prepared a branch for Benoit to test. I have pushed the
patches with Thomas Acked-by's and renamed eeprom node based on
v3.17-rc1 to

https://github.com/shesselba/linux-dove.git devel/mvebu-ix4

Sebastian
