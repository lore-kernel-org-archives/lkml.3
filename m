Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752173AbaA2MmD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 07:42:03 -0500
Received: from mail-oa0-f51.google.com ([209.85.219.51]:49378 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089AbaA2MmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 07:42:00 -0500
MIME-Version: 1.0
In-Reply-To: <4202760.m9CxkiIWk3@wuerfel>
References: <4202760.m9CxkiIWk3@wuerfel>
Date: Wed, 29 Jan 2014 13:41:59 +0100
Message-ID: <CACRpkdbd1FOOZOrF5crh3dYfYOy1CaYFH-SOqw_SJmd39JBjhg@mail.gmail.com>
Subject: Re: iop32x: gpio breakage after "instantiate GPIO from platform device"
From: Linus Walleij <linus.walleij@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 28, 2014 at 10:05 PM, Arnd Bergmann <arnd@arndb.de> wrote:

> Commit 7b85b867b9904 "ARM: plat-iop: instantiate GPIO from platform
> device" nicely cleaned up the gpio register access for iop, but
> forgot one board that directly pokes into the gpio registers
> to do a system reset.
>
> That board no longer compiles, and this patch just disables
> the code in question to work around it so I can locally build
> randconfig again, but it needs to be fixed properly.

OK I'm sending a proper fix instead.

Yours,
Linus Walleij
