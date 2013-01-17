Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759524Ab3AQKWk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 05:22:40 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:37094 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759491Ab3AQKWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 05:22:38 -0500
MIME-Version: 1.0
In-Reply-To: <20130109130004.GF31678@gmail.com>
References: <1357725965-27342-1-git-send-email-lee.jones@linaro.org>
	<1357725965-27342-2-git-send-email-lee.jones@linaro.org>
	<201301091018.55058.arnd@arndb.de>
	<20130109103510.GE3931@n2100.arm.linux.org.uk>
	<20130109110840.GD31678@gmail.com>
	<20130109111209.GH3931@n2100.arm.linux.org.uk>
	<20130109122323.GE31678@gmail.com>
	<20130109123853.GJ3931@n2100.arm.linux.org.uk>
	<20130109130004.GF31678@gmail.com>
Date: Thu, 17 Jan 2013 11:22:38 +0100
Message-ID: <CACRpkdZfhuR=dcx1Si=Yz=ezaEpTUNbDdfa32ZaT1OJ24RkXog@mail.gmail.com>
Subject: Re: [PATCH 2/3] ARM: ux500: Turn on the 'heartbeat' LED trigger
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, sameo@linux.intel.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linus.walleij@stericsson.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 9, 2013 at 2:00 PM, Lee Jones <lee.jones@linaro.org> wrote:

>> If a user has to edit the configuration files in order to configure the
>> kernel as they desire, then the configuration system has failed - or we
>> have failed to properly think out how to represent the allowable
>> configurations.
>
> Understood. Thanks for the explanation.
>
> Linus, is it okay to put these in the defconfig instead?
>
> If so, I'll fixup.

Sure, go ahead (I bet I already have a patch higher up
in my mailbox).

Yours,
Linus Walleij
