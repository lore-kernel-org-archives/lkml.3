Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752090AbaJAOlv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 10:41:51 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:59234 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155AbaJAOlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 10:41:49 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Kumar Gala <galak@codeaurora.org>
Subject: Re: [GIT PULL] qcom SoC changes for v3.18
Date: Wed, 1 Oct 2014 16:41:43 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-35-generic; KDE/4.3.2; x86_64; ; )
Cc: arm@kernel.org, Kevin Hilman <khilman@linaro.org>,
        "linux-arm-msm" <linux-arm-msm@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Olof Johansson <olof@lixom.net>,
        linux-arm-kernel@lists.infradead.org, Lina Iyer <lina.iyer@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Olav Haugan <ohaugan@codeaurora.org>, markivx@codeaurora.org
References: <A246CCDC-948C-429E-9FC5-934D317EB9D4@codeaurora.org>
In-Reply-To: <A246CCDC-948C-429E-9FC5-934D317EB9D4@codeaurora.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201410011641.44037.arnd@arndb.de>
X-Provags-ID: V02:K0:Hv+iHzyshXs4AgO48FEokBYesz/palV9pzCzXY4FXE6
 MR0QxBYq/i2SNhdS0xI50nQnKjhK+Y9sr/NNsrnQMG6jXU9TDV
 G64fSOIZn5O56+F2YUAto2pVlxsUz4HxYcPG+GMx3saABbucal
 zmOzcxNYq/BQk4+Rf2L8HuRcjFZ3PK7O1wS5YmYRuPURmBfER0
 pFZiVYC3sW77+aAtzza5rIVDNC1ndxCUYLdmfnAOIbMnzZp5Ar
 1MuJdKtAnQ/scf6YVcgKoTj819qkcX6TkZ9cQ6EksoNAgpvFOh
 CiAomNBWcgRXAulmIJBikrDhO94uYc+IdGHuhK9bK1dPUA5tZv
 SP7e7aaTcFtKqJh2hz2E=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 22 September 2014, Kumar Gala wrote:
> The following changes since commit 7d1311b93e58ed55f3a31cc8f94c4b8fe988a2b9:
> 
>   Linux 3.17-rc1 (2014-08-16 10:40:26 -0600)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/galak/linux-qcom.git tags/qcom-soc-for-3.18
> 
> for you to fetch changes up to 525fbb55947177cdae507b0d292f43c2c9a75a47:
> 
>   ARM: qcom: Move scm-boot files to drivers/soc and include/soc (2014-09-18 18:14:01 -0500)
> 
> ----------------------------------------------------------------
> Qualcomm ARM Based SoC Updates for v3.18
> 
> * Moved scm support into drivers/soc/qcom (allows for use by drivers)
> * Various bug fixes and minor feature additions to scm code
> * Added big-endian support to debug MSM uart

Pulled it into next/late now. This means we're not sending it together with the
other pull requests to Linus. We'll see how things go during the first week
and may or may not send it in the second week of the merge window depending
on that.

	Arnd
