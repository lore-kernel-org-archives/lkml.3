Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754810Ab3L0Veb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 16:34:31 -0500
Received: from mail-qe0-f54.google.com ([209.85.128.54]:37742 "EHLO
	mail-qe0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754778Ab3L0Vea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 16:34:30 -0500
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <1388135456.5072.3.camel@x220>
References: <1388123524-9000-1-git-send-email-olof@lixom.net>
	<1388135456.5072.3.camel@x220>
Date: Fri, 27 Dec 2013 13:34:29 -0800
Message-ID: <CAOesGMg9ha3MBXpo3_GM5oKxp-Pm_3LvKz1oJh=FbzgcMh3S5g@mail.gmail.com>
Subject: Re: [PATCH] mtd: nand: remove pasemi_nand driver
From: Olof Johansson <olof@lixom.net>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: David Woodhouse <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 27, 2013 at 1:10 AM, Paul Bolle <pebolle@tiscali.nl> wrote:
> On Thu, 2013-12-26 at 21:52 -0800, Olof Johansson wrote:
>> The PA Semi platform is sparsely used these days (with just a handful
>> of known users out there). I'm 100% sure none of them use the MTD NAND
>> driver -- most standard use cases include PCI-e SATA controllers for
>> storage instead, and boot is done from LPC NOR flash.
>>
>> So, there's little reason to keep carrying a driver that's not used by
>> anybody and that just gets hit by some tree-wide or tools-based changes
>> every now and then.
>>
>> Signed-off-by: Olof Johansson <olof@lixom.net>
>> ---
>>  drivers/mtd/nand/pasemi_nand.c |  238 ----------------------------------------
>>  1 file changed, 238 deletions(-)
>>  delete mode 100644 drivers/mtd/nand/pasemi_nand.c
>
> If this gets accepted we should remove the related entry in
> drivers/mtd/nand/Kconfig and the related line in
> drivers/mtd/nand/Makefile too, shouldn't we?

D'oh. Yes, of course. v2 coming.


-Olof
