Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752422Ab3A3CxH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 21:53:07 -0500
Received: from mail-ee0-f54.google.com ([74.125.83.54]:36889 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326Ab3A3CxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 21:53:04 -0500
MIME-Version: 1.0
In-Reply-To: <CAOAMb1Bf-kB1=HkgMd_w-5v6Wh0XVX4knotiOu5CLKqQg+3X9g@mail.gmail.com>
References: <CAOAMb1AsetjcNa_K6g=6K_s=0+tTH1aGLuX8emYrfgJOcx54cw@mail.gmail.com>
	<CACRpkdaECZ5qtUVS=28eDyzLWvxx=mP6dWML5mYs9kwqnhEoJQ@mail.gmail.com>
	<CAOAMb1CCoOWgab7NYYYRVjoQBoBx4XDeeLOBjJ4RzsBwRpXv6Q@mail.gmail.com>
	<CACRpkdZw_Bvz86PeNyoSjFR=O0_KkM6uJBYZ-ZhVy_g0SKun7w@mail.gmail.com>
	<CAOAMb1Bf-kB1=HkgMd_w-5v6Wh0XVX4knotiOu5CLKqQg+3X9g@mail.gmail.com>
Date: Wed, 30 Jan 2013 11:53:01 +0900
X-Google-Sender-Auth: 36F5JefI3SVOwtry_cbFO10NMVY
Message-ID: <CAOAMb1DTTH21N9sVA6FNt3TJ_n0_CXmC81UdW4YwO+zx+XdAKg@mail.gmail.com>
Subject: Re: [PATCH v2] ARM: PL011: Add support for Rx DMA buffer polling
From: Chanho Min <chanho.min@lge.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>, linux-kernel@vger.kernel.org,
        Pawel Moll <pawel.moll@arm.com>, linux-serial@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Anyway I just want to know we still need auto scale of poll rate.
I correct the mistake in this sentence.
Anyway I just want to know whether we still need auto scale of poll rate or not.

Thanks
Chanho
