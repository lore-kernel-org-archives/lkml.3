Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752349AbaIYWcw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 18:32:52 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:44033 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708AbaIYWcv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 18:32:51 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: [GIT PULL] qcom defconfig changes for v3.18
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <676B1050-4098-4E8C-A60D-07D86C3BF289@codeaurora.org>
Date: Thu, 25 Sep 2014 17:32:47 -0500
Cc: Kevin Hilman <khilman@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Olof Johansson <olof@lixom.net>,
        linux-arm-kernel@lists.infradead.org
Content-Transfer-Encoding: 8BIT
Message-Id: <72A3FBD7-E56F-4FFB-A50C-12DBB41F413F@codeaurora.org>
References: <676B1050-4098-4E8C-A60D-07D86C3BF289@codeaurora.org>
To: arm@kernel.org
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 22, 2014, at 3:14 PM, Kumar Gala <galak@codeaurora.org> wrote:

> The following changes since commit 7d1311b93e58ed55f3a31cc8f94c4b8fe988a2b9:
> 
>  Linux 3.17-rc1 (2014-08-16 10:40:26 -0600)
> 
> are available in the git repository at:
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/galak/linux-qcom.git tags/qcom-defconfig-for-3.18
> 
> for you to fetch changes up to 3b6357a79b7b0a2c3b31c5c92d5dd0c51cda0391:
> 
>  ARM: qcom: Update defconfig (2014-09-22 13:59:08 -0500)
> 
> ----------------------------------------------------------------
> Qualcomm ARM Based defconfig Updates for v3.18
> 
> * General defconfig update to match upstream changes
> * Enable IPQ806x & APQ8084 clk support
> * Enable pinctrl on MSM8960 & APQ8084
> * Enable CPU_IDLE to get basic wfi support
> * Enable SPI NOR and MTD M25P80 support (used on AP148 board)
> * Enable SATA PHY support on IPQ806x and APQ8064
> * Enable Fixed regulator and ARM MMCI support (mmc support on APQ8064)
> 
> ----------------------------------------------------------------
> Kumar Gala (2):
>      ARM: qcom: Update defconfig
>      ARM: qcom: Update defconfig
> 
> arch/arm/configs/qcom_defconfig | 14 ++++++++++----
> 1 file changed, 10 insertions(+), 4 deletions(-)

ping.

- k

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

