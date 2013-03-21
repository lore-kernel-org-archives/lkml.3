Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753915Ab3CUWaV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 18:30:21 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:43940 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753503Ab3CUWaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 18:30:19 -0400
Message-ID: <514B89F7.3000408@gmail.com>
Date: Thu, 21 Mar 2013 23:30:15 +0100
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Rob Herring <robherring2@gmail.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Grant Likely <grant.likely@secretlab.ca>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Olof Johansson <olof@lixom.net>, Nicolas Pitre <nico@fluxnic.net>,
        Lior Amsalem <alior@marvell.com>, Maen Suleiman <maen@marvell.com>,
        Tawfik Bayouk <tawfik@marvell.com>, Shadi Ammouri <shadi@marvell.com>,
        Eran Ben-Avi <benavi@marvell.com>,
        Yehuda Yitschak <yehuday@marvell.com>,
        Nadav Haklai <nadavh@marvell.com>, Ike Pan <ike.pan@canonical.com>,
        Chris Van Hoof <vanhoof@canonical.com>,
        Dan Frazier <dann.frazier@canonical.com>,
        Leif Lindholm <leif.lindholm@arm.com>, Jon Masters <jcm@redhat.com>,
        David Marlin <dmarlin@redhat.com>
Subject: Re: [PATCH 5/5] arm: dts: Convert mvebu device tree files to 64 bits
References: <1363883179-1361-1-git-send-email-gregory.clement@free-electrons.com> <201303211903.52383.arnd@arndb.de> <20130321201807.7cb04978@skate> <201303212131.07629.arnd@arndb.de>
In-Reply-To: <201303212131.07629.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21/2013 10:31 PM, Arnd Bergmann wrote:
> On Thursday 21 March 2013, Thomas Petazzoni wrote:
>> In the mean time can we do something like:
>>
>>          soc {
>>                  compatible = "simple-bus";
>>                  range =<...>;
>>
>>                  [... all the peripherals ...]
>>          };
>>
>> with the range =<...>  property converting the peripheral registers
>> base address (expressed as offsets in the reg =<...>  properties of the
>> subnodes) into the absolute physical address?
>
> Yes, that is what Rob suggested you do.

Thomas,

have a look at arch/arm/boot/dts/dove.dtsi, it uses ranges-property
and peripherals encoded as offsets.

Sebastian
