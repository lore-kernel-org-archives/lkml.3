Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752265AbaJAOkL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 10:40:11 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:54217 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751970AbaJAOkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 10:40:08 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Kumar Gala <galak@codeaurora.org>
Subject: Re: [GIT PULL] qcom defconfig changes for v3.18
Date: Wed, 1 Oct 2014 16:39:30 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-35-generic; KDE/4.3.2; x86_64; ; )
Cc: arm@kernel.org, Kevin Hilman <khilman@linaro.org>,
        "linux-arm-msm" <linux-arm-msm@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Olof Johansson <olof@lixom.net>,
        linux-arm-kernel@lists.infradead.org
References: <676B1050-4098-4E8C-A60D-07D86C3BF289@codeaurora.org>
In-Reply-To: <676B1050-4098-4E8C-A60D-07D86C3BF289@codeaurora.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201410011639.31055.arnd@arndb.de>
X-Provags-ID: V02:K0:oHtyXf1P76KUIWJkNpuP1KPUUdwjaUothNKQZyJit2t
 jNSkgwBBf8YU2vOYGkbBLM2lB9SemCoCTwE9zDhDbOY7xLwWWC
 mRVC0vteLnU70+IIei99s7DfKhcZUKdW54MN80HrZkzs+yq/7j
 3Ze7XsItLHzMiCxAwQF5+TBIv1TQIbEbimEOXdU7vtSdjvfBan
 lG0bVwmetetf6y7y0CyBGC/ifbgNCssjDCEq891a0qmM1B1mZT
 NRniflm/tkaKShQle+uJxmucQEbVv39bVzvhQ6Kz+zeTMwxdzd
 STE5wyPlskcnoSyNTE32O0TPwA4l4XFtk2jiq8PS4is3f2x6dk
 Tl8cBMU3KvSVdgmSlOK8=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 22 September 2014, Kumar Gala wrote:
> Qualcomm ARM Based defconfig Updates for v3.18
> 
> * General defconfig update to match upstream changes
> * Enable IPQ806x & APQ8084 clk support
> * Enable pinctrl on MSM8960 & APQ8084
> * Enable CPU_IDLE to get basic wfi support
> * Enable SPI NOR and MTD M25P80 support (used on AP148 board)
> * Enable SATA PHY support on IPQ806x and APQ8064
> * Enable Fixed regulator and ARM MMCI support (mmc support on APQ8064)

This seems harmless, so I've pulled it into next/defconfig now.
Sorry for the delay, I basically stopped pulling anything that only
came in last week when it seemed that we'd have merge window opening
already.

	Arnd
