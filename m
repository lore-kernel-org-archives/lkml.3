Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933030AbaGVWZQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 18:25:16 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:50761 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932958AbaGVWZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 18:25:03 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Matt Porter <mporter@linaro.org>, devicetree@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Christian Daudt <bcm@fixthebug.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Sebastian Reichel <sre@kernel.org>,
        Gregory Fong <gregory.0xf0@gmail.com>, Olof Johansson <olof@lixom.net>,
        Brian Norris <computersforpeace@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH v8 00/11] ARM: brcmstb: Add Broadcom STB SoC support
Date: Wed, 23 Jul 2014 00:24:23 +0200
Message-ID: <6456081.JRV4vu9CHq@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140722213350.GX2593@beef>
References: <1405976886-27807-1-git-send-email-computersforpeace@gmail.com> <5044348.IEPQPrahyu@wuerfel> <20140722213350.GX2593@beef>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:UXPjAKK8l/EgMTloqoBaJmEjgJ3/EMfw1IKVQJB3hvV
 P80rmVwHci+zSytxtDRONwHHzjxMo3cKuuLmAz813/5m2r5C+Y
 4cmUcp3XzZHW9BJMxliWG5YS5Idelt0lVl+sgjffkRCMwUVA1j
 sB5W7I9rRxgAdv8bXLXyAtjB3J4+IVilAPXBO+Q32IJhWGkJ3y
 LAZfduEYxbF6hzRYCstYOWM5ocoOiWmwe8njK7VocmMWDMXNI4
 1ezcZx/eXXRGSQG+MYZjad7pDM1Jrla4VFrLYj2YMYgHym0Ota
 o6CvdzwdomUtSJWrdw5OQasrd0XTfh3Ea1HT4QxHIHGudxj1t6
 gvP4plCzemeMBScnCYJM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 22 July 2014 17:33:50 Matt Porter wrote:
> 
> > > For the reset of mach-bcm stuff, I'll just send an arm-soc pull request
> > > soon enough, unless Matt/Arnd/Olof object.
> > 
> > I'll wait for Matt to comment before pulling it, otherwise that sounds
> > fine.
> 
> I'm fine with it, but we were asked to have one request for bcm5301x to
> make life easy for the arm-soc team. If we want each platform to do pull
> requests directly with arm-soc we should advise Hauke to do the same as
> well with bcm5301x. I think the chances of Kconfig/Makefile conflicts are
> relatively low as there's a dwindling amount of code of interest in new
> platform mach directories like ours.
> 
> I would like to see a consistent path for all BCM platform maintainers.
> 

Ok. Brian, please send the pull request or patches to Matt then.

	Arnd
