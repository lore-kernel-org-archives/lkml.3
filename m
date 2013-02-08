Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1947178Ab3BHVlX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 16:41:23 -0500
Received: from mail-ie0-f176.google.com ([209.85.223.176]:37008 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760321Ab3BHVlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 16:41:22 -0500
MIME-Version: 1.0
In-Reply-To: <20130208001458.GA24140@earth.universe>
References: <CACRpkdZD6XWxgVFfO3-h_8+2y36o4mnT+ZW0d+GAVTOpC2yWRA@mail.gmail.com>
	<CACRpkdZmM4oNhXcaFWEFLkABCLcxEXDRxKmoev=_vx4g+o0qtA@mail.gmail.com>
	<CACRpkdZxOW_Zk3dv45RraUM6dyOTEifcfASuBDehxB4SsYKgsw@mail.gmail.com>
	<20130208001458.GA24140@earth.universe>
Date: Fri, 8 Feb 2013 22:41:19 +0100
Message-ID: <CACRpkdZFgVtMYBOfz3hKFLZnRXX3PThna1aFNKTFNC_ec7wx7g@mail.gmail.com>
Subject: Re: HSI subsystem status
From: Linus Walleij <linus.walleij@linaro.org>
To: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Deepak Saxena <dsaxena@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 8, 2013 at 1:14 AM, Sebastian Reichel <sre@debian.org> wrote:
> On Mon, Jan 07, 2013 at 03:38:21PM +0100, Linus Walleij wrote:
>> >> what is the status on the HSI subsystem? We have based some patches for
>> >> HSI master on top of the OMAP HSI master patches, but these never seem
>> >> to reach the tree?
>> >
>> > Ping on the cch.devel address instead...
>> And ping on Carlos' private mail address, hehe :-)
>
> Did you receive a private answer? I'm interested in seeing OMAP HSI
> patches in the mainline kernel, so that the Nokia N900 modem can be
> used with a mainline kernel.

Yes, so realizing that this needs maintenance, and since it is part of
the HW in several Linaro member company boards, I put an item forward
to Linaro, who work cross ARM-boards, to try to locate a new
(co-)maintainer for HSI. However that needs to be processed and
prioritized.
https://blueprints.launchpad.net/linux-linaro/+spec/hsi-subsystem-maint

Yours,
Linus Walleij
