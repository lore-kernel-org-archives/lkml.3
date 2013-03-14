Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751451Ab3CNIB1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 04:01:27 -0400
Received: from mail-ia0-f176.google.com ([209.85.210.176]:64824 "EHLO
	mail-ia0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009Ab3CNIB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 04:01:26 -0400
MIME-Version: 1.0
In-Reply-To: <CANqRtoTFP+CycXJ-CNiFxN5iL14GTwpirs0p5HLFmeShAxvDJQ@mail.gmail.com>
References: <20130305003219.14792.13300.sendpatchset@w520>
	<CACRpkdbTXoB_zf1axVaM89Uoxa-vXWwgEHv9nWU-jbo_P1pioA@mail.gmail.com>
	<CANqRtoTFP+CycXJ-CNiFxN5iL14GTwpirs0p5HLFmeShAxvDJQ@mail.gmail.com>
Date: Thu, 14 Mar 2013 09:01:25 +0100
Message-ID: <CACRpkdYAynEEz__2MvXQNxbg-HLJVX9kutJeZeYBU6Y4Ka_N4w@mail.gmail.com>
Subject: Re: [PATCH] gpio: Renesas R-Car GPIO driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: linux-kernel@vger.kernel.org, grant.likely@secretlab.ca,
        horms@verge.net.au, linux-sh@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 14, 2013 at 5:07 AM, Magnus Damm <magnus.damm@gmail.com> wrote:
> On Thu, Mar 14, 2013 at 2:20 AM, Linus Walleij <linus.walleij@linaro.org> wrote:

>> It is quite common to request IRQ on *both* rising and falling edges,
>> what happens then?
(...)
> I may be wrong, but the switch above does AND with IRQ_TYPE_SENSE_MASK
> which makes me believe that the BOTH case will result in -EINVAL.

Yes you're right, I wasn't quite following. The code only
allows for one distinct flag, fine!

Yours,
Linus Walleij
