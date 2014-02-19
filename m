Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755010AbaBSTaw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 14:30:52 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:47520 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754604AbaBSTav convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 14:30:51 -0500
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 7.1 \(1827\))
Subject: Re: [GIT PULL] qcom cleanups for v3.15
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <5304FE4B.1020408@codeaurora.org>
Date: Wed, 19 Feb 2014 13:30:45 -0600
Cc: arm@kernel.org, David Brown <davidb@codeaurora.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Kevin Hilman <khilman@linaro.org>,
        Rohit Vaswani <rvaswani@codeaurora.org>
Content-Transfer-Encoding: 7BIT
Message-Id: <E25A5939-BFC3-44AF-9A7D-C7E8013720A6@codeaurora.org>
References: <alpine.DEB.2.00.1402101722170.12284@galak-ubuntu.qualcomm.com> <5303F56A.9010107@codeaurora.org> <FE60A8A0-B1C4-46F2-96E8-95FE25503DAF@codeaurora.org> <5304FE4B.1020408@codeaurora.org>
To: Stephen Boyd <sboyd@codeaurora.org>
X-Mailer: Apple Mail (2.1827)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 19, 2014, at 12:56 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:

> On 02/19/14 07:20, Kumar Gala wrote:
>> On Feb 18, 2014, at 6:06 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:
>> 
>>> On 02/10/14 15:23, Kumar Gala wrote:
>>>> Kumar Gala (6):
>>>>     ARM: dts: msm: split out msm8660 and msm8960 soc into dts include
>>>>     ARM: msm: kill off hotplug.c
>>>>     clocksource: qcom: Move clocksource code out of mach-msm
>>>>     ARM: qcom: Split Qualcomm support into legacy and multiplatform
>>> Sorry to nag, but can you please address my comment on this patch?
>> Which comment?  The copyright one or something else?
>> 
> 
> Yes the copyright one.

Was going to send that as a separate patch.  So no reason to hold up this pull request on it.

- k

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

