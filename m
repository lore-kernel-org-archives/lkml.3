Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753651AbbATKHK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 05:07:10 -0500
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:61677 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752181AbbATKHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 05:07:07 -0500
Message-ID: <1421748424.9655.107.camel@x220>
Subject: Re: [PATCH 8/8] regulator: MT6397: Add support for MT6397 regulator
From: Paul Bolle <pebolle@tiscali.nl>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Eddie Huang <eddie.huang@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Mark Brown <broonie@kernel.org>, Flora Fu <flora.fu@mediatek.com>,
        Liam Girdwood <lgirdwood@gmail.com>
Date: Tue, 20 Jan 2015 11:07:04 +0100
In-Reply-To: <1421747231-554-9-git-send-email-s.hauer@pengutronix.de>
References: <1421747231-554-1-git-send-email-s.hauer@pengutronix.de>
	 <1421747231-554-9-git-send-email-s.hauer@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 20 Jan 2015 10:07:05.0218 (UTC) FILETIME=[D7B1EE20:01D03498]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2015-01-20 at 10:47 +0100, Sascha Hauer wrote:
> From: Flora Fu <flora.fu@mediatek.com>
> 
> This adds support for the regulators on the MediaTek MT6397
> Multifunction device.
> 
> Signed-off-by: Flora Fu, MediaTek
> Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> Cc: Liam Girdwood <lgirdwood@gmail.com>
> Cc: Mark Brown <broonie@kernel.org>
> ---
>  Documentation/devicetree/bindings/mfd/mt6397.txt   |  41 ++-

This looks new for linux-next ...

>  .../bindings/regulator/mt6397-regulator.txt        | 217 ++++++++++++++

but this is already in linux-next. See linux-next commit 269675757901
("regulator: Add document for MT6397 regulator"). And ...

>  drivers/regulator/Kconfig                          |   9 +
>  drivers/regulator/Makefile                         |   1 +
>  drivers/regulator/mt6397-regulator.c               | 332 +++++++++++++++++++++
>  include/linux/regulator/mt6397-regulator.h         |  49 +++

these are too. See linux-next commit 0425e2420c0a ("egulator: mt6397:
Add support for MT6397 regulator"). Unless there are difference that
can't be spotted by looking at the diffstats of those commist, that is.

I only noticed because I was looking at the progress of the patch that
adds MFD_MT6397, and found this series. (MFD_MT6397 is added in 7/8, by
the way.)

>  6 files changed, 626 insertions(+), 23 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/regulator/mt6397-regulator.txt
>  create mode 100644 drivers/regulator/mt6397-regulator.c
>  create mode 100644 include/linux/regulator/mt6397-regulator.h


Paul Bolle

