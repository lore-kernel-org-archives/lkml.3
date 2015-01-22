Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753749AbbAVBEh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 20:04:37 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:33902 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751759AbbAVBE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 20:04:29 -0500
Date: Wed, 21 Jan 2015 17:04:29 -0800
From: Olof Johansson <olof@lixom.net>
To: Kumar Gala <galak@codeaurora.org>
Cc: arm@kernel.org, Kevin Hilman <khilman@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Stephen Boyd <sboyd@codeaurora.org>, pramod.gurav@smartplayin.com
Subject: Re: [GIT PULL] qcom DT changes for v3.20
Message-ID: <20150122010429.GI29014@quad.lixom.net>
References: <alpine.DEB.2.02.1501191224310.2973@galak-ubuntu.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1501191224310.2973@galak-ubuntu.qualcomm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 19, 2015 at 12:25:51PM -0600, Kumar Gala wrote:
> The following changes since commit 97bf6af1f928216fd6c5a66e8a57bfa95a659672:
> 
>   Linux 3.19-rc1 (2014-12-20 17:08:50 -0800)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/galak/linux-qcom.git tags/qcom-dt-for-3.20
> 
> for you to fetch changes up to bb901bd6596e93fc2e0fc6da2f367a651bd8d16e:
> 
>   ARM: dts: qcom: Correct IPQ8064 tlmm interrupt (2015-01-19 12:11:41 -0600)
> 
> ----------------------------------------------------------------
> Qualcomm ARM Based Device Tree Updates for v3.20
> 
> * Correct IPQ8064 tlmm interrupt
> * Add Support for SD Card Detect for ifc6410 board
> 
> ----------------------------------------------------------------
> Pramod Gurav (1):
>       ARM: dts: qcom: Add Support for SD Card Detect for ifc6410 board
> 
> Stephen Boyd (1):
>       ARM: dts: qcom: Correct IPQ8064 tlmm interrupt

Merged, thanks.


-Olof
