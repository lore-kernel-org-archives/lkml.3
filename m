Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752073AbaJPRw2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 13:52:28 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:57391 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751334AbaJPRw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 13:52:26 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:157d:b52d:4c07:5bea:2dd9]
In-Reply-To: <4AF7ABD3-EC90-47B8-96F3-B0AC396C52CC@codeaurora.org>
References: <A246CCDC-948C-429E-9FC5-934D317EB9D4@codeaurora.org>
	<201410011641.44037.arnd@arndb.de>
	<4AF7ABD3-EC90-47B8-96F3-B0AC396C52CC@codeaurora.org>
Date: Thu, 16 Oct 2014 10:52:25 -0700
Message-ID: <CAOesGMgqJrpV_i4f82_eWDLCnOONipCu4fLJ-5n-T56N=8KXWw@mail.gmail.com>
Subject: Re: [GIT PULL] qcom SoC changes for v3.18
From: Olof Johansson <olof@lixom.net>
To: Kumar Gala <galak@codeaurora.org>
Cc: Arnd Bergmann <arnd@arndb.de>, "arm@kernel.org" <arm@kernel.org>,
        Kevin Hilman <khilman@linaro.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Lina Iyer <lina.iyer@linaro.org>, Stephen Boyd <sboyd@codeaurora.org>,
        Olav Haugan <ohaugan@codeaurora.org>, markivx@codeaurora.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Oct 15, 2014 at 1:18 AM, Kumar Gala <galak@codeaurora.org> wrote:
>
> On Oct 1, 2014, at 4:41 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>
>> On Monday 22 September 2014, Kumar Gala wrote:
>>> The following changes since commit 7d1311b93e58ed55f3a31cc8f94c4b8fe988a2b9:
>>>
>>>  Linux 3.17-rc1 (2014-08-16 10:40:26 -0600)
>>>
>>> are available in the git repository at:
>>>
>>>  git://git.kernel.org/pub/scm/linux/kernel/git/galak/linux-qcom.git tags/qcom-soc-for-3.18
>>>
>>> for you to fetch changes up to 525fbb55947177cdae507b0d292f43c2c9a75a47:
>>>
>>>  ARM: qcom: Move scm-boot files to drivers/soc and include/soc (2014-09-18 18:14:01 -0500)
>>>
>>> ----------------------------------------------------------------
>>> Qualcomm ARM Based SoC Updates for v3.18
>>>
>>> * Moved scm support into drivers/soc/qcom (allows for use by drivers)
>>> * Various bug fixes and minor feature additions to scm code
>>> * Added big-endian support to debug MSM uart
>>
>> Pulled it into next/late now. This means we're not sending it together with the
>> other pull requests to Linus. We'll see how things go during the first week
>> and may or may not send it in the second week of the merge window depending
>> on that.
>>
>>       Arnd
>
> Any update if you guys will end up sending this to linus for 3.18 or not?

There ended up being several issues with the next/late branch so I
believe the current outlook is that we'll not send it.

(Arnd has been handling most of the 3.18 stuff and he might have
changed his mind since we last talked about it, but that's the state
as far as i know).


-Olof
