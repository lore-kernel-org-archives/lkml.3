Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935226Ab3E2VfW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 17:35:22 -0400
Received: from mail1.bemta8.messagelabs.com ([216.82.243.206]:37208 "EHLO
	mail1.bemta8.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932609Ab3E2VfQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 17:35:16 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-5.tower-132.messagelabs.com!1369863303!11433691!9
X-Originating-IP: [216.166.12.98]
X-StarScan-Received: 
X-StarScan-Version: 6.9.6; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Lars Poeschel <poeschel@lemonage.de>,
        Thierry Reding <thierry.reding@gmail.com>
CC: Arnd Bergmann <arnd@arndb.de>, Linux Kernel <linux-kernel@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Ryan Mallon <rmallon@gmail.com>,
        "mcrapet@gmail.com" <mcrapet@gmail.com>
Date: Wed, 29 May 2013 16:33:21 -0500
Subject: RE: [PATCH 00/14] misc/ep93xx_pwm: cleanup driver for conversion to
 PWM framework
Thread-Topic: [PATCH 00/14] misc/ep93xx_pwm: cleanup driver for conversion
 to PWM framework
Thread-Index: Ac5bmGgtlVMDojCgSx+HocMYCiv4GwBGvI7Q
Message-ID: <ADE657CA350FB648AAC2C43247A983F0021DA657044E@AUSP01VMBX24.collaborationhost.net>
References: <201305241619.52328.hartleys@visionengravers.com>
 <201305271912.08882.arnd@arndb.de> <20130528110011.GC11547@mithrandir>
 <201305281342.05530.poeschel@lemonage.de>
In-Reply-To: <201305281342.05530.poeschel@lemonage.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, May 28, 2013 4:42 AM, Lars Poeschel wrote:
> On Tuesday 28 May 2013 at 13:00:12, Thierry Reding wrote:
>> I've added Lars Poeschel on Cc, who's done some work on a sysfs
>> interface for the PWM subsystem already. It's undergone some review
>> already[0] and I think he's working on a v2 now.
>> 
>> Thierry
>> 
>> [0]: http://marc.info/?l=linux-kernel&m=136499756101273&w=2
>
> I currently do not have the time to work on a v2 of the pwm sysfs patch but 
> I will do it as soon as possible - if not someone else will do. 
> Unfortunately my current involvements in other project will not allow me to 
> do so for at least next two months.
> I received some off-list reactions to my patches from users asking for pwm 
> sysfs, so there is definitely a need for it!
> If you decide to take attempt 2) (which is preferable) I recommend you to 
> take a look at what I have done and Thierrys review comments. I took the 
> gpiolib way and the result got rejected for very good reasons.

I just posted a PWM sysfs interface patch based on the previous work by
Lars. Hopefully I addressed all of Thierrys review comments.

I still need to add the Documentation and the ABI doc for the sysfs but I
want to make sure the interface looks acceptable.

I also spotted a couple checkpatch.pl issues after I posted the patch. These
are already fixed for v2.

Thanks,
Hartley

