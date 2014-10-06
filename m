Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752044AbaJFJPE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 05:15:04 -0400
Received: from top.free-electrons.com ([176.31.233.9]:54355 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751140AbaJFJO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 05:14:59 -0400
Message-ID: <54325D8F.4050300@free-electrons.com>
Date: Mon, 06 Oct 2014 11:14:55 +0200
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Benoit Masson <benoitm@perenite.com>
CC: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Benoit Masson <yahoo@perenite.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/8] Armada XP pinctrl consolidation and ix4-300d fixes
References: <1411157684-6991-1-git-send-email-sebastian.hesselbarth@gmail.com> <-7443282711873112734@unknownmsgid> <20141003141102.GJ3895@titan.lakedaemon.net> <542EBB93.108@gmail.com> <A9781A2E-F3CA-4E8A-833C-D167B456D9F7@perenite.com> <542EC3A3.1060605@gmail.com> <1ACB5318-863E-40D8-8B27-41F1C0D0A4B8@perenite.com> <54324922.906@gmail.com> <BAB12F2D-0142-4362-BA04-59D8E6B16AAE@perenite.com>
In-Reply-To: <BAB12F2D-0142-4362-BA04-59D8E6B16AAE@perenite.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benoit,

>>> NR_IRQS:16 nr_irqs:16 16
>>> L2C: device tree omits to specify unified cache
>>
>> Jason, Thomas, Gregory,
>>
>> we should add a "cache-unified" to the l2cc nodes for all SoCs.
> 
> It seems all armada dtsi using marvell,aurora-system-cache doesn't have the "cache-unified" entry isn't this on purpose ?
> 

No it was not really done in purpose. It was missing from the beginning.
As the aurora l2cc was not a real l2x0 l2cc we put the minimal configuration.
But I've just checked and the aurora l2cc is unified too, so a patch
is coming soon to update the dtsi for Armada 370 and Armada XP.



-- 
Gregory Clement, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
