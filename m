Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753550AbbAPK1G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 05:27:06 -0500
Received: from mout.kundenserver.de ([212.227.17.13]:54792 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753083AbbAPK1B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 05:27:01 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Chunyan Zhang <chunyan.zhang@spreadtrum.com>
Cc: gregkh@linuxfoundation.org, mark.rutland@arm.com,
        gnomes@lxorguk.ukuu.org.uk, broonie@kernel.org, robh+dt@kernel.org,
        pawel.moll@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, will.deacon@arm.com, catalin.marinas@arm.com,
        jslaby@suse.cz, jason@lakedaemon.net, heiko@sntech.de,
        florian.vaussard@epfl.ch, andrew@lunn.ch, rrichter@cavium.com,
        hytszk@gmail.com, grant.likely@linaro.org, antonynpavlov@gmail.com,
        Joel.Schopp@amd.com, Suravee.Suthikulpanit@amd.com,
        shawn.guo@linaro.org, lea.yan@linaro.org,
        jorge.ramirez-ortiz@linaro.org, lee.jones@linaro.org,
        orsonzhai@gmail.com, geng.ren@spreadtrum.com,
        zhizhou.zhang@spreadtrum.com, lanqing.liu@spreadtrum.com,
        zhang.lyra@gmail.com, wei.qiao@spreadtrum.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        linux-api@vger.kernel.org
Subject: Re: [PATCH v5 5/5] tty/serial: Add Spreadtrum sc9836-uart driver support
Date: Fri, 16 Jan 2015 11:26:08 +0100
Message-ID: <2026679.CiQSN0uJXp@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1421402411-3479-6-git-send-email-chunyan.zhang@spreadtrum.com>
References: <1421402411-3479-6-git-send-email-chunyan.zhang@spreadtrum.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:ZirRNCp/AezHXidkfT3MA/LDgo7YAUh2NQHRhz6Pr/e5M70VNs3
 UbNFkRTeeTTA+9C9oV9VgjQ9uyRWe5B4bST0eXhlEk/ypD7X8qc1Mvf+sEIlrf/AJS2kV9L
 Qn7jh7tr3K/shz4CRn4lgIHPh62N1p8GdcKDbqsdogMvrWBpIXILRbuuA1nNX8qn5SFaX+2
 k3Mm4pMLM35YIgbgOL+sQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 16 January 2015 18:00:11 Chunyan Zhang wrote:
> Add a full sc9836-uart driver for SC9836 SoC which is based on the
> spreadtrum sharkl64 platform.
> This driver also support earlycon.
> This patch also replaced the spaces between the macros and their
> values with the tabs in serial_core.h
> 
> Signed-off-by: Chunyan Zhang <chunyan.zhang@spreadtrum.com>
> Signed-off-by: Orson Zhai <orson.zhai@spreadtrum.com>
> Originally-by: Lanqing Liu <lanqing.liu@spreadtrum.com>
> 

I see nothing wrong with the patch contents, but a few things regarding
the submission process:

- The 'Signed-off-by' lines are in the wrong order. As the person
  sending it, your S-o-b should be the last one in the list

- You have too many people on 'To'. Please send the patch only to
  the person you expect to apply it, and put the other people that
  may be interested on Cc. A lot of the people who got this mail
  are probably not interested and you can drop them completely.

- Now that everything is reviewed, split the series according to
  subsystem maintainers and send it separately: patches 1,2 and 5
  should go to GregKH as one series, the rest should go to
  'arm@kernel.org'.

- For some reason I did not get patch 4. Can you check if that
  made it to the mailing list?

Feel free to add my 'Acked-by: Arnd Bergmann <arnd@arndb.de>' to
the patches you send to Greg.

	Arnd
