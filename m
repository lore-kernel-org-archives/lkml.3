Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751486AbaJOISl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 04:18:41 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:41893 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751207AbaJOISi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 04:18:38 -0400
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: [GIT PULL] qcom SoC changes for v3.18
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <201410011641.44037.arnd@arndb.de>
Date: Wed, 15 Oct 2014 10:18:30 +0200
Cc: arm@kernel.org, Kevin Hilman <khilman@linaro.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Olof Johansson <olof@lixom.net>,
        linux-arm-kernel@lists.infradead.org, Lina Iyer <lina.iyer@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Olav Haugan <ohaugan@codeaurora.org>, markivx@codeaurora.org
Content-Transfer-Encoding: 7BIT
Message-Id: <4AF7ABD3-EC90-47B8-96F3-B0AC396C52CC@codeaurora.org>
References: <A246CCDC-948C-429E-9FC5-934D317EB9D4@codeaurora.org> <201410011641.44037.arnd@arndb.de>
To: Arnd Bergmann <arnd@arndb.de>
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 1, 2014, at 4:41 PM, Arnd Bergmann <arnd@arndb.de> wrote:

> On Monday 22 September 2014, Kumar Gala wrote:
>> The following changes since commit 7d1311b93e58ed55f3a31cc8f94c4b8fe988a2b9:
>> 
>>  Linux 3.17-rc1 (2014-08-16 10:40:26 -0600)
>> 
>> are available in the git repository at:
>> 
>>  git://git.kernel.org/pub/scm/linux/kernel/git/galak/linux-qcom.git tags/qcom-soc-for-3.18
>> 
>> for you to fetch changes up to 525fbb55947177cdae507b0d292f43c2c9a75a47:
>> 
>>  ARM: qcom: Move scm-boot files to drivers/soc and include/soc (2014-09-18 18:14:01 -0500)
>> 
>> ----------------------------------------------------------------
>> Qualcomm ARM Based SoC Updates for v3.18
>> 
>> * Moved scm support into drivers/soc/qcom (allows for use by drivers)
>> * Various bug fixes and minor feature additions to scm code
>> * Added big-endian support to debug MSM uart
> 
> Pulled it into next/late now. This means we're not sending it together with the
> other pull requests to Linus. We'll see how things go during the first week
> and may or may not send it in the second week of the merge window depending
> on that.
> 
> 	Arnd

Any update if you guys will end up sending this to linus for 3.18 or not?

- k

-- 
Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

