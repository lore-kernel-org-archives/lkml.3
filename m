Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752628AbaG1OOP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 10:14:15 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:43545 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752164AbaG1OOK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 10:14:10 -0400
Content-Type: text/plain; charset=iso-8859-1
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: [PATCH 2/2] V4 ARM: mvebu: Added dts defintion for Lenovo Iomega ix4-300d NAS
From: Benoit Masson <benoitm@perenite.com>
In-Reply-To: <20140728140805.GQ23220@titan.lakedaemon.net>
Date: Mon, 28 Jul 2014 16:13:59 +0200
Cc: Benoit Masson <yahoo@perenite.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        andrew@lunn.ch, gregory.clement@free-electrons.com,
        sebastian.hesselbarth@googlemail.com
Content-Transfer-Encoding: 8BIT
Message-Id: <02CE8576-5CD8-4AA5-971E-85CBC8CE05D3@perenite.com>
References: <1406503839-4662-1-git-send-email-yahoo@perenite.com> <20140728140805.GQ23220@titan.lakedaemon.net>
To: Jason Cooper <jason@lakedaemon.net>
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Le 28 juil. 2014 à 16:08, Jason Cooper <jason@lakedaemon.net> a écrit :

> Benoit,
> 
> On Sun, Jul 27, 2014 at 04:30:39PM -0700, Benoit Masson wrote:
>> The Lenovo Iomega ix4-300d is a 4-Bay sata NAS with dual Gb,
>> USB2.0 & 3.0, powered by a Marvell Armada XP MV78230 dual core CPU.
>> 
>> http://shop.lenovo.com/us/en/servers/network-storage/lenovoemc/ix4-300d/
>> Signed-off-by: Benoit Masson <yahoo@perenite.com>
>> ---
>> arch/arm/boot/dts/Makefile                      |   3 +-
>> arch/arm/boot/dts/armada-xp-lenovo-ix4-300d.dts | 285 ++++++++++++++++++++++++
>> 2 files changed, 287 insertions(+), 1 deletion(-)
>> create mode 100644 arch/arm/boot/dts/armada-xp-lenovo-ix4-300d.dts
> 
> I've applied this to mvebu/dt with a few minor fixups.
> 
>  - Insert empty line between URL and S-o-B
>  - Removed i2c compatible property
>  - Removed trailing whitespace from multi-line comment at end of file
> 
> Also, traditionally, the 'V4' goes inside the square brackets, eg
> 
>  [ PATCH V4 2/2 ] ...
> 
> This is done because 'git am ...' automagically removes everything
> between the square brackets and then takes the rest of the subject line
> to be the first line of the commit message.
> 
> Well done!

Thanks Jason and all for supporting this and following up long discussions on A0 stepping ... !

Just one question is how would you link this patch to the quirk a0 patch since this patch can't work without it ...

> 
> You can view the commit here:
> 
>  http://git.infradead.org/linux-mvebu.git/commitdiff/40c2da45366171bdc9ad1968489aaae190248383
> 
> thx,
> 
> Jason.

