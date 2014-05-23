Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752393AbaEWSoB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 14:44:01 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:54762 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751588AbaEWSn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 14:43:59 -0400
Date: Fri, 23 May 2014 13:43:56 -0500 (CDT)
From: Kumar Gala <galak@codeaurora.org>
X-X-Sender: galak@galak-ubuntu.qualcomm.com
To: arm@kernel.org
cc: Kevin Hilman <khilman@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Olof Johansson <olof@lixom.net>,
        David Brown <davidb@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org, gregkh@linuxfoundation.org,
        paul@pwsan.com, santosh.shilimkar@ti.com, agross@codeaurora.org,
        sandeep_n@ti.com
Subject: Re: [GIT PULL] qcom driver changes for v3.16
Message-ID: <alpine.DEB.2.00.1405231342160.15680@galak-ubuntu.qualcomm.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit c9eaa447e77efe77b7fa4c953bd62de8297fd6c5:

   Linux 3.15-rc1 (2014-04-13 14:18:35 -0700)

are available in the git repository at:

   git://git.kernel.org/pub/scm/linux/kernel/git/galak/linux-qcom.git tags/qcom-drivers-for-3.16

for you to fetch changes up to 5d144e36b7c51612922fa05d37ff3a869261cc82:

   soc: qcom: Add GSBI driver (2014-05-23 11:38:04 -0500)

----------------------------------------------------------------
Qualcomm ARM Based driver Updates for v3.16

* Introduce drivers/soc directory for misc SoC specific code
* Add driver to configure GSBI device

----------------------------------------------------------------
Andy Gross (1):
       soc: qcom: Add GSBI driver

Santosh Shilimkar (1):
       soc: Introduce drivers/soc place-holder for SOC specific drivers

  drivers/Kconfig              |  2 ++
  drivers/Makefile             |  3 ++
  drivers/soc/Kconfig          |  5 +++
  drivers/soc/Makefile         |  5 +++
  drivers/soc/qcom/Kconfig     | 11 ++++++
  drivers/soc/qcom/Makefile    |  1 +
  drivers/soc/qcom/qcom_gsbi.c | 84 ++++++++++++++++++++++++++++++++++++++++++++
  7 files changed, 111 insertions(+)
  create mode 100644 drivers/soc/Kconfig
  create mode 100644 drivers/soc/Makefile
  create mode 100644 drivers/soc/qcom/Kconfig
  create mode 100644 drivers/soc/qcom/Makefile
  create mode 100644 drivers/soc/qcom/qcom_gsbi.c

--
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation
