Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751412AbaEWUKt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 16:10:49 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:62302 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146AbaEWUKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 16:10:48 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Kumar Gala <galak@codeaurora.org>
Subject: Re: [GIT PULL] qcom SoC changes for v3.16
Date: Fri, 23 May 2014 22:10:41 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-35-generic; KDE/4.3.2; x86_64; ; )
Cc: arm@kernel.org, Kevin Hilman <khilman@linaro.org>,
        "linux-arm-msm" <linux-arm-msm@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Olof Johansson <olof@lixom.net>,
        David Brown <davidb@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org, agross@codeaurora.org,
        linus.walleij@linaro.org, iivanov@mm-sol.com,
        srinivas.kandagatla@linaro.org
References: <alpine.DEB.2.00.1405231339340.15680@galak-ubuntu.qualcomm.com>
In-Reply-To: <alpine.DEB.2.00.1405231339340.15680@galak-ubuntu.qualcomm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201405232210.41738.arnd@arndb.de>
X-Provags-ID: V02:K0:2X9QgxA5lUwxPlygefLyV+t+251iJC1+pDPgxDhPV3Q
 ZEei3uiul3w9tYCV8100F9M+mjxFE4u+mDIn4haaLhXkucomr5
 HVUQizQzzZK/Tzm3JiI/e4cMWdeKu8DExGA201IwSo6tIdUVta
 Iuyy3tgTmmtQNUYN8TcuG3wo5mQrpKuPKcs9j/SqAWf/R8M2rn
 ghASeQMp+7xvUTe01dJrIr4i+QYp6wzy4pFCLbx1aKtzzL7K6n
 F6Qoddl5qBFQZrRDsLlR8T0NZa7wC5lRDu9jxbhTS3Y7n9qYlt
 K2urKzZpf9Eyi1V3wfCWT3Ci6a2GlCR4wn1mXPoi5F3ZXPZh5q
 fUA6sEcdiM6936QNSABw=
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
>    git://git.kernel.org/pub/scm/linux/kernel/git/galak/linux-qcom.git tags/qcom-soc-for-3.16
> 
> for you to fetch changes up to 87cfb00d666cca3abf36f755279cde1b27b9c377:
> 
>    ARM: qcom: Select PINCTRL by default for ARCH_QCOM (2014-05-22 11:50:42 -0500)
> 
> ----------------------------------------------------------------
> Qualcomm ARM Based SoC Updates for v3.16
> 
> * Enabling building pinctrl and AMBA bus support
> * Clean up debug UART selection

Pulled into next/soc, thanks!

	Arnd
