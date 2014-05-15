Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752463AbaEOM7F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 08:59:05 -0400
Received: from exprod7og126.obsmtp.com ([64.18.2.206]:48420 "EHLO
	exprod7og126.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604AbaEOM7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 08:59:03 -0400
MIME-Version: 1.0
In-Reply-To: <30207873.oHzEC0kjdd@wuerfel>
References: <cover.1400072260.git.anders.berg@avagotech.com>
	<6334605.NlytHCzYVP@wuerfel>
	<CAE0=X_15Yk3VhHTwG-piA_eYL1mKW9wu_Szp-yL0YyfL8m0ecA@mail.gmail.com>
	<30207873.oHzEC0kjdd@wuerfel>
Date: Thu, 15 May 2014 14:59:00 +0200
Message-ID: <CAE0=X_2YsfGRZHC5XY0F-5Td_k20s7ADRhhv=3a9bRT7wqxNGw@mail.gmail.com>
Subject: Re: [PATCH v3 0/6] Add platform support for LSI AXM55xx
From: Anders Berg <anders.berg@avagotech.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org,
        Mike Turquette <mturquette@linaro.org>,
        devicetree <devicetree@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        Olof Johansson <olof@lixom.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2014 at 2:39 PM, Arnd Bergmann <arnd@arndb.de> wrote:

> I don't see the dependency: The clock driver is built only when CONFIG_ARCH_AXXIA
> is set, and that only gets introduced in the platform patches. As long
> as the header files come with the platform, it should be fine.

You're right of course. I didn't think that all the way though...

I'll send a v4 of the series (minus the clk patch) when I get an OK on
the binding of the clk driver.

/Anders
