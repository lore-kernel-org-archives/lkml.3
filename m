Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752280AbaJSUvU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 16:51:20 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:61036 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750947AbaJSUvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 16:51:18 -0400
Date: Sun, 19 Oct 2014 13:51:16 -0700
From: Olof Johansson <olof@lixom.net>
To: Kumar Gala <galak@codeaurora.org>
Cc: arm@kernel.org, Kevin Hilman <khilman@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        linux-kernel@vger.kernel.org, David Brown <davidb@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org,
        Mike Rapoport <mike.rapoport@gmail.com>,
        Tim Bird <tim.bird@sonymobile.com>
Subject: Re: [GIT PULL] qcom DT changes for v3.18-3
Message-ID: <20141019205116.GB10595@quad.lixom.net>
References: <FBA74704-E00F-4CD5-A07C-56B72F6755DA@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <FBA74704-E00F-4CD5-A07C-56B72F6755DA@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2014 at 10:03:48AM +0200, Kumar Gala wrote:
> The following changes since commit aabff7bfe55afd01d71a5f11d4a84bd873c20f5e:
> 
>   ARM: DT: msm8960: Add sdcc nodes (2014-09-22 13:49:43 -0500)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/galak/linux-qcom.git tags/qcom-dt-for-3.18-3
> 
> for you to fetch changes up to 7dac24bdc1dd561573cd8ce534a63dc975f51ca8:
> 
>   ARM: dts: qcom: add CM-QS600 board (2014-10-16 02:48:36 -0500)
> 
> ----------------------------------------------------------------
> Qualcomm ARM Based Device Tree Updates for v3.18-3
> 
> * Added Board support for CM-QS600 and Sony Xperia Z1 phone
> * Added SATA support on IPQ8064/AP148

In general we try to avoid merging all that much dt contents late,
but since Kevin wanted the Xperia stuff added I've merged this in now.


-Olof
