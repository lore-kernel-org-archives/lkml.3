Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755841Ab3AVUqy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 15:46:54 -0500
Received: from mail-ob0-f169.google.com ([209.85.214.169]:62580 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751567Ab3AVUqx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 15:46:53 -0500
Message-ID: <50FEFAB9.4030503@gmail.com>
Date: Tue, 22 Jan 2013 14:46:49 -0600
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Matt Sealey <matt@genesi-usa.com>, Lior Amsalem <alior@marvell.com>,
        Andrew Lunn <andrew@lunn.ch>, Ike Pan <ike.pan@canonical.com>,
        John Stultz <johnstul@us.ibm.com>, David Marlin <dmarlin@redhat.com>,
        Yehuda Yitschak <yehuday@marvell.com>,
        Jani Monoses <jani.monoses@canonical.com>,
        Russell King <linux@arm.linux.org.uk>,
        Tawfik Bayouk <tawfik@marvell.com>,
        Dan Frazier <dann.frazier@canonical.com>,
        Eran Ben-Avi <benavi@marvell.com>,
        Leif Lindholm <leif.lindholm@arm.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Jason Cooper <jason@lakedaemon.net>, Nadav Haklai <nadavh@marvell.com>,
        Jon Masters <jcm@redhat.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux ARM Kernel ML <linux-arm-kernel@lists.infradead.org>,
        Chris Van Hoof <vanhoof@canonical.com>,
        LKML <linux-kernel@vger.kernel.org>, Maen Suleiman <maen@marvell.com>,
        Shadi Ammouri <shadi@marvell.com>
Subject: Re: [PATCH 3/6] arm: kconfig: don't select TWD with local timer for
 Armada 370/XP
References: <1358790842-2986-1-git-send-email-gregory.clement@free-electrons.com> <201301211831.45947.arnd@arndb.de> <CAKGA1b=9WQNwHOz=k13XVc=MyZT1UrcaYj8muF2A5B4eJA5+MA@mail.gmail.com> <201301212044.41865.arnd@arndb.de>
In-Reply-To: <201301212044.41865.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21/2013 02:44 PM, Arnd Bergmann wrote:

>> On multiplatform kernels where at least one arch has TWD support, it
>> will be included, and where not, it will not.
>>
>> It doesn't seem logical for a feature descriptor (HAVE_ARM_TWD) to
>> rely on greater knowledge of what platforms may or may not support it.
>> If we had to include every platform in that list it would be unwieldy.
> 
> I would expect that all future platforms have ARM_TWD, so the list
> of the platforms that don't is not going to grow much, but the list
> of platforms that do will keep growing.

No, I expect all future platforms will have architected timers. TWD is
pretty much A9 and A5 only I believe. Same with SCU. I've probably
missed some in my list.

Rob

