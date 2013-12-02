Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752941Ab3LBM5M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 07:57:12 -0500
Received: from mail-oa0-f52.google.com ([209.85.219.52]:39306 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752250Ab3LBM5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 07:57:10 -0500
MIME-Version: 1.0
In-Reply-To: <20131202114638.GH16735@n2100.arm.linux.org.uk>
References: <1385983731-13196-1-git-send-email-panchaxari.prasannamurthy@linaro.org>
	<1385983731-13196-2-git-send-email-panchaxari.prasannamurthy@linaro.org>
	<20131202114638.GH16735@n2100.arm.linux.org.uk>
Date: Mon, 2 Dec 2013 13:57:10 +0100
Message-ID: <CACRpkdZv9cZekBfJ2P1G4pMYOyAobmA2mszF=kN0Db5TC6_5+Q@mail.gmail.com>
Subject: Re: [PATCH] ARM:INTEGRATOR: Default enable ARM_PATCH_PHYS_VIRT, AUTO_ZRELADDR
From: Linus Walleij <linus.walleij@linaro.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: panchaxari <panchaxari.prasannamurthy@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Michal Simek <monstr@monstr.eu>,
        Olof Johansson <olof@lixom.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 2, 2013 at 12:46 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Mon, Dec 02, 2013 at 04:58:51PM +0530, panchaxari wrote:
>>
>> Requesting maintainers of Integrator platform to evaluate the changes on the
>> board and comment, as I dont have the board for testing and also requesting
>> an ACK.
>
> This is _exactly_ the kind of patches I don't want to see - people
> running around changing platforms with no way to test them.

Actually, blame me for this. I asked Pancham to send the patch
to the mail list so I would be able to pick it and test it ... I guess
it would have been less confusing if I had just taken the patch
in private and tested it and then sent it out instead...

> If you want to do such work, send the patches with "[CFT]" in the
> subject line - call for testing.

Good point, I've also seen "[RFT]" (request for testing) in some
cases.

Anyway, I'll just go test this thing now and see if it works as
intended.

Yours,
Linus Walleij
