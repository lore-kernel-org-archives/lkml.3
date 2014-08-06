Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754182AbaHFTnP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 15:43:15 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:40075 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753987AbaHFTnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 15:43:11 -0400
MIME-Version: 1.0
In-Reply-To: <5570bdf5ebb3aaae5a376634ecfbac9c2fd7b9f4.1396384101.git.stefan@agner.ch>
References: <cover.1396384101.git.stefan@agner.ch>
	<5570bdf5ebb3aaae5a376634ecfbac9c2fd7b9f4.1396384101.git.stefan@agner.ch>
Date: Wed, 6 Aug 2014 12:43:10 -0700
X-Google-Sender-Auth: e08DQZbvG-S5z1llxwoAFolffw0
Message-ID: <CAD=FV=WjfHC_yR=1QrTWz+K5zv02c4sixngfsy8sX5zhDd0ppw@mail.gmail.com>
Subject: Re: [RFC 1/2] mmc: read mmc alias from device tree
From: Doug Anderson <dianders@chromium.org>
To: stefan@agner.ch, Chris Ball <chris@printf.net>,
        Ulf Hansson <ulf.hansson@linaro.org>
Cc: "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        Addy Ke <addy.ke@rock-chips.com>,
        Andrew Bresticker <abrestic@chromium.org>,
        Olof Johansson <olof@lixom.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan,

On Tue, Apr 1, 2014 at 1:35 PM,  <stefan@agner.ch> wrote:
> From: Stefan Agner <stefan@agner.ch>
>
> To get the SD/MMC host device ID, read the alias from the device
> tree.
>
> This is useful in case a SoC has multipe SD/MMC host controllers while
> the second controller should logically be the first device (e.g. if
> the second controller is connected to an internal eMMC). Combined
> with block device numbering using MMC/SD host device ID, this
> results in predictable name assignment of the internal eMMC block
> device.
>
> Signed-off-by: Stefan Agner <stefan@agner.ch>

Yes, please.  It is very handy to have mmc devices be enumerated in a
predictable way.

Reviewed-by: Doug Anderson <dianders@chromium.org>
Tested-by: Doug Anderson <dianders@chromium.org>
