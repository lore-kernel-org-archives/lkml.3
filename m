Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752319AbbATSYx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 13:24:53 -0500
Received: from mail-ob0-f177.google.com ([209.85.214.177]:36948 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667AbbATSYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 13:24:51 -0500
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:157d:d9ac:c0f7:a023:e45e]
In-Reply-To: <20150120171048.GF7718@atomide.com>
References: <20150120110947.1a92a416@canb.auug.org.au>
	<20150120171048.GF7718@atomide.com>
Date: Tue, 20 Jan 2015 10:24:50 -0800
Message-ID: <CAOesGMjc+q5ZEFU4GugJT2RCSmhv48DAA8JzuCxf63eEO6tWVQ@mail.gmail.com>
Subject: Re: linux-next: manual merge of the omap tree with the arm-soc tree
From: Olof Johansson <olof@lixom.net>
To: Tony Lindgren <tony@atomide.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Robinson <pbrobinson@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2015 at 9:10 AM, Tony Lindgren <tony@atomide.com> wrote:
> * Stephen Rothwell <sfr@canb.auug.org.au> [150119 16:12]:
>> Hi Tony,
>>
>> Today's linux-next merge of the omap tree got a conflict in
>> arch/arm/boot/dts/Makefile between commit cb612390e546 ("ARM: dts: Only
>> build dtb if associated Arch and/or SoC is enabled") from the arm-soc
>> tree and commit ac7452cee743 ("ARM: dts: Add minimal support for
>> dm8168-evm") from the omap tree.
>>
>> I fixed it up (see below) and can carry the fix as necessary (no action
>> is required).
>
> Uhh why is cb612390e546 doing formatting changes all over the place?
> That's a sure way to produce merge conflicts..

It's intentional but a but annoying, yes -- we're resolving them as we
merge in new DT contents so it won't be exposed outside of our tree
(and -next, unfortunately).


-Olof
