Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752025AbaIXFi4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 01:38:56 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:37855 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902AbaIXFiy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 01:38:54 -0400
Date: Tue, 23 Sep 2014 22:26:47 -0700
From: Olof Johansson <olof@lixom.net>
To: Kumar Gala <galak@codeaurora.org>
Cc: arm@kernel.org, Kevin Hilman <khilman@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        linux-kernel@vger.kernel.org, David Brown <davidb@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org,
        Georgi Djakov <gdjakov@mm-sol.com>, pramod.gurav@smartplayin.com,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>
Subject: Re: [GIT PULL] qcom DT changes for v3.18
Message-ID: <20140924052647.GE30340@localhost>
References: <13536005-9FFF-4362-8B87-5F0DC9930D29@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <13536005-9FFF-4362-8B87-5F0DC9930D29@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 12, 2014 at 02:40:41PM -0500, Kumar Gala wrote:
> The following changes since commit 7d1311b93e58ed55f3a31cc8f94c4b8fe988a2b9:
> 
>   Linux 3.17-rc1 (2014-08-16 10:40:26 -0600)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/galak/linux-qcom.git tags/qcom-dt-for-3.18
> 
> for you to fetch changes up to edb81ca3bf586ad526ee67b245cb87f7c7142a87:
> 
>   ARM: DT: QCOM: apq8064: Add dma support for sdcc node (2014-09-11 12:07:40 -0500)
> 
> ----------------------------------------------------------------
> Qualcomm ARM Based Device Tree Updates for v3.18
> 
> * Added APQ8084 dt support for clocks, serial, pinctrl, and IFC6540 board
> * Added IPQ8064 dt support for basic SoC and AP148 board
> * Added APQ8064 dt support for pinctrl, reset, SDHC, and multimedia clocks
> * Added PMIC 8058 dt support on MSM8660, enables PMIC based power key,
>   keypad, rtc, and vibrator
> * Added PMIC 8921 dt support on MSM8960, enables PMIC based power key,
>   keypad, and rtc

Merged, thanks.


-Olof
