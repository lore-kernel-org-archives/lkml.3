Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754926AbaFBN0Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 09:26:16 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:53774 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754717AbaFBN0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 09:26:14 -0400
MIME-Version: 1.0
In-Reply-To: <20140602123851.GB2654@katana>
References: <1401452797-29521-1-git-send-email-lee.jones@linaro.org>
	<1401452797-29521-2-git-send-email-lee.jones@linaro.org>
	<20140530123656.GC2742@katana>
	<20140530133405.GB29731@lee--X1>
	<20140530174800.GA4917@katana>
	<20140530192516.GA4319@lee--X1>
	<20140531134805.GA3287@katana>
	<CACRpkdZvyfA0aaJe3YuevXfA2pTZLRPZ3mQpitL6qD7=qE0Xyg@mail.gmail.com>
	<20140602123851.GB2654@katana>
Date: Mon, 2 Jun 2014 15:26:13 +0200
Message-ID: <CACRpkdbnzy3rSXQ8AFAYmtM93MGKmRj2F566LMvKDhtSw2MLxQ@mail.gmail.com>
Subject: Re: [PATCH] i2c: Make I2C ID tables non-mandatory for DT'ed and/or
 ACPI'ed devices
From: Linus Walleij <linus.walleij@linaro.org>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: Grant Likely <grant.likely@linaro.org>, Lee Jones <lee.jones@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 2, 2014 at 2:38 PM, Wolfram Sang <wsa@the-dreams.de> wrote:

> Though, I wouldn't mind if compatible entries could be passed to the
> 'new_device' file, in addition to i2c_device_ids. Yet, this needs some
> extra handling I haven't found the time for, yet.

Hm that's a way forward then I guess... but passing a compatible
string to that same file is a bit arbitrarily ambigous. So we'd rather
add a new instatiation file named new_device_of_compatible or so?

Yours,
Linus Walleij
