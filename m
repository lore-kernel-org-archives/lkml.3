Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751454AbaEWWtd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 18:49:33 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:59523 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010AbaEWWtc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 18:49:32 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Kumar Gala <galak@codeaurora.org>
Subject: Re: [GIT PULL] qcom driver changes for v3.16
Date: Sat, 24 May 2014 00:48:52 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-35-generic; KDE/4.3.2; x86_64; ; )
Cc: arm@kernel.org, Kevin Hilman <khilman@linaro.org>,
        "linux-arm-msm" <linux-arm-msm@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Olof Johansson <olof@lixom.net>,
        David Brown <davidb@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org, gregkh@linuxfoundation.org,
        paul@pwsan.com, santosh.shilimkar@ti.com, agross@codeaurora.org,
        sandeep_n@ti.com
References: <alpine.DEB.2.00.1405231342160.15680@galak-ubuntu.qualcomm.com>
In-Reply-To: <alpine.DEB.2.00.1405231342160.15680@galak-ubuntu.qualcomm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201405240048.52555.arnd@arndb.de>
X-Provags-ID: V02:K0:QPDF3QZOkBQcIwyRAGm3tGqMOBNsK+692yfttHTWMkW
 FKLhZLwip+ZXH6K4esBmmRlxVDT0NPjWPN526LUHrwi55YiqSJ
 IzVj6ySYE6CpKdKrjcqt+6Nid1g/XyAu0qDqfJO2cBsc5DBOWO
 321BPeH+0Nc6Zrob1mrC8PaLgdPD79Z5O7cns9KS3v5sp7MPz6
 poC+dD+oFmHVa7blIs2fA0X6onBQnMjq1kcaMRq5bj9B4ZzbTv
 ao0JulXVBcbRK0Ch1+JdslW26I2LPQWey9W2TD8x9FPKa7iZAR
 MSZPG5Jc7gGMygKFdCUQLufCooK45wK3GVsUGxycmlqhQQU70f
 e5L0dJWxcKqaaAMtTYWw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 23 May 2014, Kumar Gala wrote:
> The following changes since commit c9eaa447e77efe77b7fa4c953bd62de8297fd6c5:
> 
>    Linux 3.15-rc1 (2014-04-13 14:18:35 -0700)
> 
> are available in the git repository at:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/galak/linux-qcom.git tags/qcom-drivers-for-3.16
> 
> for you to fetch changes up to 5d144e36b7c51612922fa05d37ff3a869261cc82:
> 
>    soc: qcom: Add GSBI driver (2014-05-23 11:38:04 -0500)
> 
> ----------------------------------------------------------------
> Qualcomm ARM Based driver Updates for v3.16
> 
> * Introduce drivers/soc directory for misc SoC specific code
> * Add driver to configure GSBI device

Merged into next/drivers, thanks

	Arnd
