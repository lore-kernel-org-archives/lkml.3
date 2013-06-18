Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753112Ab3FRHwN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 03:52:13 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:34325 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186Ab3FRHwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 03:52:11 -0400
MIME-Version: 1.0
In-Reply-To: <1371491257-23791-1-git-send-email-ttynkkynen@nvidia.com>
References: <1371491257-23791-1-git-send-email-ttynkkynen@nvidia.com>
Date: Tue, 18 Jun 2013 09:52:10 +0200
Message-ID: <CACRpkdYOPtS5Phhcz5x39heo5Bwqdn==rmXPPoQPOOy1AooFtw@mail.gmail.com>
Subject: Re: [PATCH 0/2] Fix kernel panics with certain I2C tps6* chips
From: Linus Walleij <linus.walleij@linaro.org>
To: Tuomas Tynkkynen <ttynkkynen@nvidia.com>, Wolfram Sang <wsa@the-dreams.de>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 17, 2013 at 7:47 PM, Tuomas Tynkkynen <ttynkkynen@nvidia.com> wrote:

> Hi,
>
> Latest linux-next head (next-20130617) seems to have some backwards-incompatible
> changes to the i2c core, which breaks the tps* drivers in our boards and cause
> panics on boot.

You should probably put Wolfram (the i2c maintainer) on the To: line.

> Tuomas Tynkkynen (2):
>   mfd: tps65910: Fix crash in i2c_driver .probe
>   regulator: tps62360: Fix crash in i2c_driver .probe

Nice :-)

Yours,
Linus Walleij
