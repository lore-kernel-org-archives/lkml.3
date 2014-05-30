Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756114AbaE3QlH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 12:41:07 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:59862 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754107AbaE3QlF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 12:41:05 -0400
Date: Fri, 30 May 2014 11:41:01 -0500 (CDT)
From: Kumar Gala <galak@codeaurora.org>
X-X-Sender: galak@galak-ubuntu.qualcomm.com
To: arm@kernel.org
cc: Kevin Hilman <khilman@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Olof Johansson <olof@lixom.net>,
        David Brown <davidb@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org,
        Andy Gross <agross@codeaurora.org>, gregkh@linuxfoundation.org
Subject: [GIT PULL] qcom driver changes for v3.16-2
Message-ID: <alpine.DEB.2.00.1405301138220.5291@galak-ubuntu.qualcomm.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 5d144e36b7c51612922fa05d37ff3a869261cc82:

   soc: qcom: Add GSBI driver (2014-05-23 11:38:04 -0500)

are available in the git repository at:

   git://git.kernel.org/pub/scm/linux/kernel/git/galak/linux-qcom.git tags/qcom-drivers-for-3.16-2

for you to fetch changes up to 31964ffebbb958c6cf289c7c12edd7530d6221b9:

   tty: serial: msm: Remove direct access to GSBI (2014-05-29 11:06:20 -0500)

----------------------------------------------------------------
Qualcomm ARM Based driver Updates for v3.16-2

* Updated MSM uart driver to not access GSBI control registers

----------------------------------------------------------------
Andy Gross (1):
       tty: serial: msm: Remove direct access to GSBI

  drivers/tty/serial/msm_serial.c | 48 ++---------------------------------------
  drivers/tty/serial/msm_serial.h |  5 -----
  2 files changed, 2 insertions(+), 51 deletions(-)

--
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation
