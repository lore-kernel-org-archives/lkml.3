Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755201AbaFYHyC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 03:54:02 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:38359 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755126AbaFYHx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 03:53:58 -0400
MIME-Version: 1.0
In-Reply-To: <074a01cf8fc1$e906f0c0$bb14d240$%debski@samsung.com>
References: <1403614495-9291-1-git-send-email-k.debski@samsung.com>
	<CAD8Lp441832-ZVV8FQChEXcLqVpZqygv3iaF95_SfZOH_xkFPg@mail.gmail.com>
	<074a01cf8fc1$e906f0c0$bb14d240$%debski@samsung.com>
Date: Wed, 25 Jun 2014 08:53:54 +0100
Message-ID: <CAD8Lp4468eAGGCi1v17X00342D5aqXHqwE1TY4aLu40DvO_MAg@mail.gmail.com>
Subject: Re: [PATCH] phy: phy-samsung-usb2: Change phy power on/power off sequence
From: Daniel Drake <drake@endlessm.com>
To: Kamil Debski <k.debski@samsung.com>
Cc: linux-kernel@vger.kernel.org,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        linux-usb@vger.kernel.org, kishon@ti.com,
        Tomasz Figa <t.figa@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>, gautam.vivek@samsung.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 24, 2014 at 4:35 PM, Kamil Debski <k.debski@samsung.com> wrote:
> By reboot I guess that you mean typing "reboot" or by using SysRq magic
> and not power cycling?
>
> If so, I had experienced the same symptoms. I guess that the Ethernet
> chip is not reset properly and fails to enumerate without power cycling
> (it's nRESET pin is connected to P3V3).
>
> I found that removing regulator-always-on from buck8_reg: BUCK8 in the
> dts file fixes this problem.

Yes, that fixes the problem. Thanks!

Tested-by: Daniel Drake <drake@endlessm.com>
