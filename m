Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753731Ab3AVHR5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 02:17:57 -0500
Received: from mail-da0-f51.google.com ([209.85.210.51]:33849 "EHLO
	mail-da0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752979Ab3AVHRz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 02:17:55 -0500
Date: Mon, 21 Jan 2013 23:17:57 -0800
From: Olof Johansson <olof@lixom.net>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Arnd Bergmann <arnd@arndb.de>, Stefan Roese <sr@denx.de>,
        Alejandro Mery <amery@geeks.cl>, linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/7] ARM: sunxi: olinuxino: Add muxing for the uart
Message-ID: <20130122071757.GB25783@quad.lixom.net>
References: <1358544639-14761-1-git-send-email-maxime.ripard@free-electrons.com>
 <1358544639-14761-8-git-send-email-maxime.ripard@free-electrons.com>
 <CACRpkdbUbD-VnkdSAKp=GyRiqub8iZf90nwPHPFtWZHwSMZiAA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdbUbD-VnkdSAKp=GyRiqub8iZf90nwPHPFtWZHwSMZiAA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 21, 2013 at 11:15:32PM +0100, Linus Walleij wrote:
> On Fri, Jan 18, 2013 at 10:30 PM, Maxime Ripard
> <maxime.ripard@free-electrons.com> wrote:
> 
> > Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> 
> All pinctrl and device tree patches applied to my allwinner branch in the
> pinctrl tree. Hope the ARM SoC can accept me poking around in your
> device trees.

Ah, my just-now sent reply was to an older version of this thread.

Sure, it's not a big deal that you're picking up the DT changes, but there
might end up being add/add conflicts if they are adding more stuff to the same
files. Not a huge deal, ideally we want to avoid them but a couple are ok.


-Olof
