Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754043AbaHMWLw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 18:11:52 -0400
Received: from mail-oi0-f52.google.com ([209.85.218.52]:41845 "EHLO
	mail-oi0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704AbaHMWLv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 18:11:51 -0400
MIME-Version: 1.0
In-Reply-To: <20140804165627.GT3711@ld-irv-0074>
References: <1405976886-27807-1-git-send-email-computersforpeace@gmail.com>
	<1405976886-27807-4-git-send-email-computersforpeace@gmail.com>
	<20140802083040.GY30282@n2100.arm.linux.org.uk>
	<20140804165627.GT3711@ld-irv-0074>
Date: Wed, 13 Aug 2014 15:11:50 -0700
Message-ID: <CAN8TOE8w5bUT5byHiJrYr8AzaZ+EADzE+aoH6f2x2tFc1+1eQw@mail.gmail.com>
Subject: Re: [PATCH v8 03/11] ARM: brcmstb: add debug UART for earlyprintk support
From: Brian Norris <computersforpeace@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Matt Porter <mporter@linaro.org>, Christian Daudt <bcm@fixthebug.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Gregory Fong <gregory.0xf0@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Marc Carino <marc.ceeeee@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping (Olof or Matt?)

On Mon, Aug 4, 2014 at 9:56 AM, Brian Norris
<computersforpeace@gmail.com> wrote:
> On Sat, Aug 02, 2014 at 09:30:40AM +0100, Russell King wrote:
>> On Mon, Jul 21, 2014 at 02:07:58PM -0700, Brian Norris wrote:
>> > From: Marc Carino <marc.ceeeee@gmail.com>
>> >
>> > Add the UART definitions needed to support earlyprintk on brcmstb machines.
>> >
>> > Signed-off-by: Marc Carino <marc.ceeeee@gmail.com>
>> > Acked-by: Florian Fainelli <f.fainelli@gmail.com>
>> > Signed-off-by: Brian Norris <computersforpeace@gmail.com>
>>
>> I noticed that you sent this to the patch system.  I asked Olof last
>> night whether he had anything in arm-soc touching Kconfig.debug, and
>> he does (a number of other platforms have updated it.)  This means
>> that if I apply it to my tree, it may conflict, so I'm reluctant to
>> take it.
>
> OK... Matt told me that such patches go through you. So which is it?
> Should all Kconfig.debug patches go through the arm-soc route?

How should this get in? Should I rebase/resend through Matt and
arm-soc? Or can you pick this up as-is?

Brian
