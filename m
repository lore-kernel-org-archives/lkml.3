Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754863AbaBSS4O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 13:56:14 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:43602 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754402AbaBSS4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 13:56:12 -0500
Message-ID: <5304FE4B.1020408@codeaurora.org>
Date: Wed, 19 Feb 2014 10:56:11 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Kumar Gala <galak@codeaurora.org>
CC: arm@kernel.org, David Brown <davidb@codeaurora.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Kevin Hilman <khilman@linaro.org>,
        Rohit Vaswani <rvaswani@codeaurora.org>
Subject: Re: [GIT PULL] qcom cleanups for v3.15
References: <alpine.DEB.2.00.1402101722170.12284@galak-ubuntu.qualcomm.com> <5303F56A.9010107@codeaurora.org> <FE60A8A0-B1C4-46F2-96E8-95FE25503DAF@codeaurora.org>
In-Reply-To: <FE60A8A0-B1C4-46F2-96E8-95FE25503DAF@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/19/14 07:20, Kumar Gala wrote:
> On Feb 18, 2014, at 6:06 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:
>
>> On 02/10/14 15:23, Kumar Gala wrote:
>>> Kumar Gala (6):
>>>      ARM: dts: msm: split out msm8660 and msm8960 soc into dts include
>>>      ARM: msm: kill off hotplug.c
>>>      clocksource: qcom: Move clocksource code out of mach-msm
>>>      ARM: qcom: Split Qualcomm support into legacy and multiplatform
>> Sorry to nag, but can you please address my comment on this patch?
> Which comment?  The copyright one or something else?
>

Yes the copyright one.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

