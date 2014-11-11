Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752578AbaKKVnr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 16:43:47 -0500
Received: from mout.web.de ([212.227.17.11]:61892 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752045AbaKKVnU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 16:43:20 -0500
Message-ID: <546282DC.7070606@web.de>
Date: Tue, 11 Nov 2014 22:42:52 +0100
From: Soeren Moch <smoch@web.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Robin Gong <b38343@freescale.com>, shawn.guo@linaro.org
CC: robh+dt@kernel.org, mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, shawn.guo@freescale.com, kernel@pengutronix.de,
        LW@KARO-electronics.de, sre@kernel.org, dbaryshkov@gmail.com,
        dwmw2@infradead.org, grant.likely@linaro.org, linux@arm.linux.org.uk,
        pawel.moll@arm.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 2/3] power: reset: imx-snvs-poweroff: add power off
 driver for i.mx6
In-Reply-To: <1411703947-31956-3-git-send-email-b38343@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:3PC7Kz6bHwiXu/ev0tiegeCKcVa5XQhvAvPGXjFAbQLhYTjzNnc
 ZdovzrhOqYCI4O2qt8muLAYSow3Vve0WpoSl7xwcXOvhTWhs3ZxjYiMj99vPDJKzAJUA6kG
 92Uj3L4XznVBIv7IcbmRbiLW2tHeKZmTIPTX0xc/OwYXGrWoZF6anDDuKdPSX54I9gkwQhP
 kLPdTXm3lf8sh3h6dkUmg==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This driver register pm_power_off with snvs power off function. If
> your boards NOT use PMIC_ON_REQ to turn on/off external pmic, or use
> other pin to do, please disable the driver in dts, otherwise, your
> pm_power_off maybe overwrote by this driver.

> Signed-off-by: Robin Gong <b38343@freescale.com>

Any news on this?
Maybe this patchset was lost because it was sent to the old email address of Shawn?

I tested this patchset on a TBS2910 board, works as expected.  Very important feature for me.


Tested-by: Soeren Moch <smoch@web.de>

