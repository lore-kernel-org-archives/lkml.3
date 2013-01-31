Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753681Ab3AaUdV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 15:33:21 -0500
Received: from mail-ie0-f179.google.com ([209.85.223.179]:46683 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753049Ab3AaUdS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 15:33:18 -0500
MIME-Version: 1.0
In-Reply-To: <CAOAMb1DTTH21N9sVA6FNt3TJ_n0_CXmC81UdW4YwO+zx+XdAKg@mail.gmail.com>
References: <CAOAMb1AsetjcNa_K6g=6K_s=0+tTH1aGLuX8emYrfgJOcx54cw@mail.gmail.com>
	<CACRpkdaECZ5qtUVS=28eDyzLWvxx=mP6dWML5mYs9kwqnhEoJQ@mail.gmail.com>
	<CAOAMb1CCoOWgab7NYYYRVjoQBoBx4XDeeLOBjJ4RzsBwRpXv6Q@mail.gmail.com>
	<CACRpkdZw_Bvz86PeNyoSjFR=O0_KkM6uJBYZ-ZhVy_g0SKun7w@mail.gmail.com>
	<CAOAMb1Bf-kB1=HkgMd_w-5v6Wh0XVX4knotiOu5CLKqQg+3X9g@mail.gmail.com>
	<CAOAMb1DTTH21N9sVA6FNt3TJ_n0_CXmC81UdW4YwO+zx+XdAKg@mail.gmail.com>
Date: Thu, 31 Jan 2013 21:33:17 +0100
Message-ID: <CACRpkdb8ZqS6o0NYq6Fy_GN_AUeAFs--yq4M6AvvsErVAH=-oQ@mail.gmail.com>
Subject: Re: [PATCH v2] ARM: PL011: Add support for Rx DMA buffer polling
From: Linus Walleij <linus.walleij@linaro.org>
To: Chanho Min <chanho.min@lge.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>, linux-kernel@vger.kernel.org,
        Pawel Moll <pawel.moll@arm.com>, linux-serial@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 30, 2013 at 3:53 AM, Chanho Min <chanho.min@lge.com> wrote:
>> Anyway I just want to know we still need auto scale of poll rate.

> I correct the mistake in this sentence.
> Anyway I just want to know whether we still need auto scale of poll rate or not.

For the console/TTY and modem usecase I think it's pretty much
necessary don't you think?

Else these users (which is by far the most widespread of the
kernel users) will be punished by too many wakeups if they
use DMA. And they should be able to do that, right? This is
a perfect fit for the Versatile and PB11MPcore ARM reference
designs.

Yours,
Linus Walleij
