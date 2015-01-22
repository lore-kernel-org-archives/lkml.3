Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752886AbbAVBPa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 20:15:30 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:45643 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751730AbbAVBPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 20:15:21 -0500
Date: Wed, 21 Jan 2015 17:15:21 -0800
From: Olof Johansson <olof@lixom.net>
To: Kumar Gala <galak@codeaurora.org>
Cc: arm@kernel.org, Kevin Hilman <khilman@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Stephen Boyd <sboyd@codeaurora.org>, lina.iyer@linaro.org,
        skannan@codeaurora.org, ohaugan@codeaurora.org, markivx@codeaurora.org
Subject: Re: [GIT PULL] qcom SoC changes for v3.20
Message-ID: <20150122011521.GA31815@quad.lixom.net>
References: <alpine.DEB.2.02.1501191226010.2973@galak-ubuntu.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1501191226010.2973@galak-ubuntu.qualcomm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


On Mon, Jan 19, 2015 at 12:27:15PM -0600, Kumar Gala wrote:
> The following changes since commit 97bf6af1f928216fd6c5a66e8a57bfa95a659672:
> 
>   Linux 3.19-rc1 (2014-12-20 17:08:50 -0800)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/galak/linux-qcom.git tags/qcom-soc-for-3.20
> 
> for you to fetch changes up to ae0a6075c046f9c8dbac18f53a779592f97b402e:
> 
>   soc: qcom: scm: Clarify boot interface (2015-01-19 11:55:12 -0600)
> 
> ----------------------------------------------------------------
> Qualcomm ARM Based SoC Updates for v3.20
> 
> * Moved scm support into drivers/soc/qcom (allows for use by drivers)
> * Various bug fixes and minor feature additions to scm code
> * Added big-endian support to debug MSM uart
> * Added big-endian support to ARCH_QCOM
> 
> ----------------------------------------------------------------
> Lina Iyer (2):
>       ARM: qcom: Add SCM warmboot flags for quad core targets.
>       soc: qcom: scm: Move scm-boot files to drivers/soc and include/soc
> 
> Olav Haugan (1):
>       ARM: qcom: scm: Add logging of actual return code from scm call
> 
> Saravana Kannan (1):
>       ARM: qcom: scm: Add API to query for service/command availability.
> 
> Stephen Boyd (9):
>       ARM: debug: Update MSM and QCOM DEBUG_LL help
>       ARM: debug: msm: Support big-endian CPUs
>       ARM: qcom: Select ARCH_SUPPORTS_BIG_ENDIAN
>       ARM: qcom: scm: Fix incorrect cache invalidation
>       ARM: qcom: scm: Get cacheline size from CTR
>       ARM: qcom: scm: Add a feat version query API
>       soc: qcom: scm: Move the scm driver to drivers/soc/qcom

I replied on the patch here just now. This isn't the right thing to do,
as far as I can tell.

Seems like sending a fresh request with the material besides the move
to drivers/soc should be mergeable though, so feel free to do that while
the rest is hashed out.


-Olof
