Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753437AbaBYUZ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 15:25:56 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:42910 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752585AbaBYUZy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 15:25:54 -0500
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 7.1 \(1827\))
Subject: Re: [GIT PULL] qcom driver changes for v3.15
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <201402251814.43712.arnd@arndb.de>
Date: Tue, 25 Feb 2014 14:25:48 -0600
Cc: arm@kernel.org, Kevin Hilman <khilman@linaro.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Rohit Vaswani <rvaswani@codeaurora.org>,
        Olof Johansson <olof@lixom.net>, David Brown <davidb@codeaurora.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>, robdclark@gmail.com,
        linux-arm-kernel@lists.infradead.org
Content-Transfer-Encoding: 7BIT
Message-Id: <A3153995-5372-45F4-B7AA-D39911ED405B@codeaurora.org>
References: <alpine.DEB.2.00.1402250926210.17163@galak-ubuntu.qualcomm.com> <201402251814.43712.arnd@arndb.de>
To: Arnd Bergmann <arnd@arndb.de>
X-Mailer: Apple Mail (2.1827)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 25, 2014, at 11:14 AM, Arnd Bergmann <arnd@arndb.de> wrote:

> On Tuesday 25 February 2014, Kumar Gala wrote:
>> The following changes since commit cf1e8f0cd665e2a9966d2bee4e11ecc0938ff166:
>> 
>>   ARM: qcom: Rename various msm prefixed functions to qcom (2014-02-06 16:20:41 -0600)
>> 
>> are available in the git repository at:
>> 
>>   git://git.kernel.org/pub/scm/linux/kernel/git/galak/linux-qcom.git tags/qcom-drivers-for-3.15
>> 
>> for you to fetch changes up to add798a40aec3a768165055477ba8bfee21e06fc:
>> 
>>   gpio: msm: switch Kconfig to ARCH_QCOM depends (2014-02-25 09:22:10 -0600)
>> 
> 
> Applied to the next/drivers branch now, and added a merge description
> that I adapted from your patch changelogs:
> 
>    Merge "qcom driver changes for v3.15" from Kumar Gala:
> 
>    We've split Qualcomm MSM support into legacy and multiplatform.  These
>    drivers are only relevant on the multiplatform supported SoCs so switch the
>    Kconfig depends to ARCH_QCOM.
> 
> It would be helpful if you can in the future always add a description
> yourself when creating the tag.
> 
> 	Arnd

Oops, I think when I updated the tag before sending I lost the message in the tag

- k

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

