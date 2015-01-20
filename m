Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754981AbbATLUO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 06:20:14 -0500
Received: from asav22.altibox.net ([109.247.116.9]:42012 "EHLO
	asav22.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753065AbbATLUJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 06:20:09 -0500
X-Greylist: delayed 520 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 Jan 2015 06:20:09 EST
Message-ID: <54BE37DE.9020700@tronnes.org>
Date: Tue, 20 Jan 2015 12:11:26 +0100
From: =?UTF-8?B?Tm9yYWxmIFRyw7hubmVz?= <notro@tronnes.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
CC: Valentin Rothberg <valentinrothberg@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: staging: fbtft: CONFIG_ARCH_BCM2708?
References: <1421743602.9655.83.camel@x220>
In-Reply-To: <1421743602.9655.83.camel@x220>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Antivirus: avast! (VPS 150120-0, 20.01.2015), Outbound message
X-Antivirus-Status: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Den 20.01.2015 09:46, skrev Paul Bolle:
> Thomas, Noralf,
>
> Your commit c296d5f9957c ("staging: fbtft: core support") is included in
> today's linux-next (ie, next-20150120). I noticed because a script I use
> to check linux-next spotted a problem in it.
>
> See, that commit adds two checks for CONFIG_ARCH_BCM2708. But there's no
> Kconfig symbol ARCH_BCM2708. (A comment in
> drivers/mmc/host/sdhci-bcm2835.c does suggest there's an out of tree
> "Main bcm2708 linux port".)
>
> Is the code to add the Kconfig symbol ARCH_BCM2708 queued somewhere?
Hi Paul,

ARCH_BCM2708 is used instead of ARCH_BCM2835 in the Raspberry Pi kernel 
fork.
The optimization code enabled by ARCH_BCM2708 in 
drivers/staging/fbtft/fbtft-io.c can be removed.
There will be another take on the I/O stage for those drivers later.

I can make a patch for this. Just need to find out how to setup git to 
send paches for me.

Thanks for spotting this.


Noralf.

