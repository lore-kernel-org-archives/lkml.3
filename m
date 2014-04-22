Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757197AbaDVQDm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 12:03:42 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:51627 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756396AbaDVQDi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 12:03:38 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>, Andrew Lunn <andrew@lunn.ch>,
        Jason Cooper <jason@lakedaemon.net>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Chao Xie <xiechao.mail@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] fixing regressions caused by Dove in MULTI_V7
References: <20140414151236.75f8816d@skate>
	<1397585763-23482-1-git-send-email-sebastian.hesselbarth@gmail.com>
Date: Tue, 22 Apr 2014 09:03:35 -0700
In-Reply-To: <1397585763-23482-1-git-send-email-sebastian.hesselbarth@gmail.com>
	(Sebastian Hesselbarth's message of "Tue, 15 Apr 2014 20:15:58 +0200")
Message-ID: <7hd2g9fj1k.fsf@paris.lan>
User-Agent: Gnus/5.130008 (Ma Gnus v0.8) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com> writes:

> This is a patch set fixing regressions in v3.15-rc1 ultimately caused
> by adding DT-enabled Marvell Dove to MULTI_V7. There was a fix
> introduced late in the merge window to fix a related regression for
> non-PJ4 architectures, that turned out to introduce another regression
> on PJ4B-based Armada 370/XP.

Tested-by: Kevin Hilman <khilman@linaro.org>

FWIW, I tested this series on top of v3.15-rc1 using multi_v7_defconfig
on all of multi-platform boards I have (20), and they all passed the
boot test.  Full boot report below.

Kevin


Subject: test/dove-regression boot: 20 pass, 0 fail (v3.15-rc1-5-gc1d3c1beba74)

Tree/Branch: test/dove-regression
Git describe: v3.15-rc1-5-gc1d3c1beba74
Commit: c1d3c1beba ARM: iwmmxt: allow to build iWMMXt on Marvell PJ4B

Full Report
===========

arm-multi_v7_defconfig
----------------------
    qcom-apq8074-dragonboard     0 min 15.7 sec:     PASS
                ste-snowball     1 min 20.5 sec:     PASS
              tegra30-beaver     0 min 17.1 sec:     PASS
            am335x-boneblack     0 min 37.7 sec:     PASS
             omap3-beagle-xm     0 min 47.5 sec:     PASS
       sun7i-a20-cubieboard2     0 min 12.4 sec:     PASS
          armada-370-mirabox     0 min 22.4 sec:     PASS
                 omap4-panda     0 min 58.2 sec:     PASS
  armada-xp-openblocks-ax3-4     0 min 25.2 sec:     PASS
        sun4i-a10-cubieboard     0 min 19.1 sec:     PASS
                 bcm28155-ap     0 min 27.8 sec:     PASS
            omap3-overo-tobi     0 min 22.3 sec:     PASS  (Warnings: 1)
  imx6dl-wandboard,wand-solo     0 min 18.2 sec:     PASS
                 am335x-bone     0 min 26.7 sec:     PASS
      omap3-overo-storm-tobi     0 min 20.9 sec:     PASS
                  omap5-uevm     1 min 40.0 sec:     PASS  (Warnings: 1)
                  omap3-n900     0 min 34.5 sec:     PASS  (Warnings: 1)
             imx6q-wandboard     0 min 17.2 sec:     PASS
              omap4-panda-es     0 min 54.5 sec:     PASS
  imx6dl-wandboard,wand-dual     0 min 18.1 sec:     PASS

