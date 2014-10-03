Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753640AbaJCP3l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 11:29:41 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:54492 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753301AbaJCP3g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 11:29:36 -0400
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: [PATCH 0/8] Armada XP pinctrl consolidation and ix4-300d fixes
From: Benoit Masson <benoitm@perenite.com>
In-Reply-To: <542EBB93.108@gmail.com>
Date: Fri, 3 Oct 2014 17:29:21 +0200
Cc: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Benoit Masson <yahoo@perenite.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <A9781A2E-F3CA-4E8A-833C-D167B456D9F7@perenite.com>
References: <1411157684-6991-1-git-send-email-sebastian.hesselbarth@gmail.com> <-7443282711873112734@unknownmsgid> <20141003141102.GJ3895@titan.lakedaemon.net> <542EBB93.108@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Le 3 oct. 2014 à 17:06, Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com> a écrit :

> On 10/03/2014 04:11 PM, Jason Cooper wrote:
>> On Sun, Sep 21, 2014 at 04:11:23PM +0200, Benoit Masson wrote:
>>>> Le 19 sept. 2014 à 22:14, Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com> a écrit :
>>>> this is a patch set preparing barebox support for ix4-300d. As usual,
>>>> I stumbled upon a few nice-to-haves before actually touching ix4-300d
>>>> dts. As it is a mach-mvebu thing, I just added the related mailing
>>>> lists instead of each of the DT maintainers.
>>>> 
>>>> First 5 patches consolidate SoC-specific pinctrl nodes to one common
>>>> node in armada-xp.dtsi, compatible overwrites for each SoC, and node
>>>> alias usage for each board. Also, ge{0,1} pinctrl settings are moved
>>>> to the common node from one board specific node.
>>>> 
>>>> Last 3 patches then use that ge{0,1} pinctrl settings on ix4-300d which
>>>> is vital for bootloader init. During exploration of ix4-300d, I also
>>>> found a i2c eeprom that has not been added to the dts, yet. Finally,
>>>> there is only one 74hc595 on ix4 mainboard while dts property is set
>>>> for two.
>>>> 
>>>> I cannot recall in detail what is on that eeprom, but IIRC it is nothing
>>>> important. Some reg,addr pairs for some init stuff that should have
>>>> already been done by stock u-boot. Anyway, adding the node will do no
>>>> harm.
>>>> 
>>>> Patches are based on v3.17-rc1 and intended for v3.18 but I am not in
>>>> a hurry. I only compile tested this, so a formal Tested-by from Benoit
>>>> for the ix4 and any other Armada XP board would be great.
>>> 
>>> I'm not sure what to test since I only receive some patch from the
>>> series of 8. Should I get all 8 or only those you sent me. I'll be
>>> able to test during next week.
>> 
>> Did you ever get a chance to test this series?
> 
> Uhm, I never prepared a branch for Benoit to test. I have pushed the
> patches with Thomas Acked-by's and renamed eeprom node based on
> v3.17-rc1 to
> 
> https://github.com/shesselba/linux-dove.git devel/mvebu-ix4
> 
Hi tahnks, that was my last question, because I was lost about which to apply from the list of 8.

Also I've noted you did some other patch for Armada XP not related to ix-4-300d, are they included here or should I get them too ?

I'll test those over Sunday night.

Benoit
> Sebastian

