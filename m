Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754038Ab3ESLJ2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 May 2013 07:09:28 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:35531 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753918Ab3ESLJ1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 May 2013 07:09:27 -0400
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.3 \(1503\))
Subject: Re: [RFC PATCHv3 3/6] clk: Add TI-Nspire clock drivers
From: Daniel Tang <dt.tangr@gmail.com>
In-Reply-To: <201305161417.28133.arnd@arndb.de>
Date: Sun, 19 May 2013 21:09:17 +1000
Cc: linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        Linus Walleij <linus.walleij@linaro.org>,
        "fabian@ritter-vogt.de Vogt" <fabian@ritter-vogt.de>,
        Lionel Debroux <lionel_debroux@yahoo.fr>, linux-kernel@vger.kernel.org,
        Mike Turquette <mturquette@linaro.org>
Content-Transfer-Encoding: 7BIT
Message-Id: <F8915E01-0FCA-4C9F-8440-63B5A73B349B@gmail.com>
References: <1368332581-94691-1-git-send-email-dt.tangr@gmail.com> <201305151607.54442.arnd@arndb.de> <15FD6543-D04A-4953-A56A-40B27F0026E4@gmail.com> <201305161417.28133.arnd@arndb.de>
To: Arnd Bergmann <arnd@arndb.de>
X-Mailer: Apple Mail (2.1503)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 16/05/2013, at 10:17 PM, Arnd Bergmann <arnd@arndb.de> wrote:

> On Thursday 16 May 2013, Daniel Tang wrote:
>> 
>> On 16/05/2013, at 12:07 AM, Arnd Bergmann <arnd@arndb.de> wrote:
>> 
>>> You are missing a binding in Documentation/devicetree, same as for some of
>>> the other drivers in this series.
>> 
>> Should we be adding a vendor prefix to it too? If so, we're not sure whether
>> to use "ti," or not since this isn't an official port by TI.
> 
> The binding describes the hardware, it should not matter who does the port.
> However, any part of the tree that is not actually from TI should have a
> vendor prefix indicating who made that part. IIRC, the SoC used in there
> is from TI, so you should use something else for the on-soc components.
> 

If the vendors for the on-SOC components are unknown, should we just leave the compatible strings as is (i.e. "nspire-XXX")?

>>> It seems strange to assign the clk_name variable to node->name
>>> first and then overriding it with the clock-output-names property.
>>> Is that intentional? If so, please explain it in a comment.
>>> 
>> 
>> I copied that bit of boilerplate from drivers/clk/clk-fixed-rate.c but
>> I'm guessing it's to use the node name as the clock name unless there
>> is a property called "clock-output-names"
> 
> Ah, I see. It seems you forgot to add the clock maintainer to Cc in the
> mail. Mike is the one who will have to take you patch anyway, so I assume
> he will comment on this if you did it wrong.
> 
> 	Arnd

