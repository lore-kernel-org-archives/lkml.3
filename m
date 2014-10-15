Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751906AbaJOOt6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 10:49:58 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:55800 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751325AbaJOOtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 10:49:55 -0400
Message-ID: <543E898D.10606@gmail.com>
Date: Wed, 15 Oct 2014 16:49:49 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
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
References: <1411157684-6991-1-git-send-email-sebastian.hesselbarth@gmail.com> <-7443282711873112734@unknownmsgid> <20141003141102.GJ3895@titan.lakedaemon.net> <542EBB93.108@gmail.com> <A9781A2E-F3CA-4E8A-833C-D167B456D9F7@perenite.com> <542EC3A3.1060605@gmail.com> <1ACB5318-863E-40D8-8B27-41F1C0D0A4B8@perenite.com> <5432BFB1.2060300@gmail.com> <CE7A9795-C2AF-451A-8018-3A0B8788BF60@perenite.com> <20141015144259.GB17447@titan.lakedaemon.net>
In-Reply-To: <20141015144259.GB17447@titan.lakedaemon.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/15/2014 04:42 PM, Jason Cooper wrote:
> On Wed, Oct 15, 2014 at 02:53:02AM +0200, Benoit Masson wrote:
>> Le 6 oct. 2014 à 18:13, Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com> a écrit :
>>> I prepared more branches with the series
>>> - on top of v3.17 release:
>>> https://github.com/shesselba/linux-dove.git devel/mvebu-ix4_v3.17
>>>
>>> - on top of next-20141003 (i.e. what will become v3.18-rc1):
>>> https://github.com/shesselba/linux-dove.git devel/mvebu-ix4_next-20141003
>>>
>>> It would be great, if you can test in this order:
>>> - vanilla v3.17
>>> - mvebu-ix4_v3.17
>>> - mvebu-ix4_next-20141003
>>>
>> All the 3 branch works WHEN APPLYING A0 patch (below), with both my custom kernel config and the arch/arm/configs/mvebu_v7_defconfig
>>
>> The reason why it didn't worked last time was that apparently the A0 patch (copied) below was not merged into 3.17 :(
>>
>> This means that ix4-300d support is broken on 3.17 because of the A0 stepping patch not merged.
>
> Do you have a link to an email thread or the patch Subject line?  I can
> confirm it's missing from mvebu/fixes...

http://lists.infradead.org/pipermail/linux-arm-kernel/2014-July/275487.html

But you and Andrew should check what Arnd suggested. IIRC, there
was also an appropriate follow-up patch discussion started by
Andrew.

Sebastian

