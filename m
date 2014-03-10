Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753206AbaCJDki (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2014 23:40:38 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:38481 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753149AbaCJDkf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2014 23:40:35 -0400
Date: Sun, 09 Mar 2014 23:40:32 -0400 (EDT)
Message-Id: <20140309.234032.873557698878535571.davem@davemloft.net>
To: sebastian.hesselbarth@gmail.com
Cc: rob@landley.net, andrew@lunn.ch, f.fainelli@gmail.com,
        netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: phy: Add sysfs attribute to prevent PHY suspend
From: David Miller <davem@davemloft.net>
In-Reply-To: <531D0D0D.4050703@gmail.com>
References: <531D094C.1090205@gmail.com>
	<20140309.204101.47552917508273123.davem@davemloft.net>
	<531D0D0D.4050703@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sun, 09 Mar 2014 20:40:35 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Date: Mon, 10 Mar 2014 01:53:33 +0100

> On 03/10/2014 01:41 AM, David Miller wrote:
>> From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
>> Date: Mon, 10 Mar 2014 01:37:32 +0100
>>
>>> The mechanism is manual, no automatic way to determine it.
>>
>> We recognize BIOS and ACPI bugs and work around them, by looking at
>> version information and whatnot, so you really can't convince me that
>> something similar can't be done here perhaps in the platform code.
> 
> Hmm, if the is a way to determine the version of that particual u-boot
> I'd be happy to exploit that information. But I honestly doubt that.
> Compared to u-boot bootloader and kernel interaction, BIOS and ACPI
> are well-defined protocols.
> 
> I personally, would prefer everybody should update his broken
> bootloaders, but that will just not happen.

What you can do is have a test that _perhaps_ covers a "broader than
reality" list of broken bootloader cases.

Then you have something the bootloader can provide which indicates
that it has been fixed.
