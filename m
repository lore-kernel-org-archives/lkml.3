Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753571AbaBZXDP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 18:03:15 -0500
Received: from mail-pd0-f175.google.com ([209.85.192.175]:36240 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891AbaBZXDN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 18:03:13 -0500
From: Kevin Hilman <khilman@linaro.org>
To: Kumar Gala <galak@codeaurora.org>
Cc: linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] arm: qcom: Split Qualcomm support into legacy and multiplatform
References: <1391107002-21470-1-git-send-email-galak@codeaurora.org>
	<1391107002-21470-3-git-send-email-galak@codeaurora.org>
	<7hha7m0x9w.fsf@paris.lan>
	<FF42247A-A4E8-4AA2-9C3B-BEEFC2F61714@codeaurora.org>
Date: Wed, 26 Feb 2014 15:03:10 -0800
In-Reply-To: <FF42247A-A4E8-4AA2-9C3B-BEEFC2F61714@codeaurora.org> (Kumar
	Gala's message of "Wed, 26 Feb 2014 11:22:47 -0600")
Message-ID: <7hbnxtwk7l.fsf@paris.lan>
User-Agent: Gnus/5.130008 (Ma Gnus v0.8) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kumar Gala <galak@codeaurora.org> writes:

> On Feb 26, 2014, at 8:22 AM, Kevin Hilman <khilman@linaro.org> wrote:
>
>> Kumar Gala <galak@codeaurora.org> writes:
>> 
>>> Introduce a new mach-qcom that will support SoCs that intend to be
>>> multiplatform compatiable while keeping mach-msm to legacy SoC/board
>>> support that will not transition over to multiplatform.
>>> 
>>> As part of this, we move support for MSM8X60, MSM8960 and MSM8974 over
>>> to mach-qcom.
>>> 
>>> Signed-off-by: Kumar Gala <galak@codeaurora.org>
>> 
>> Having a closer look at this after seeing the multi_v7_defconfig change,
>> I have a minor nit on the new ARCH_QCOM name.
>> 
>> For new additions, we've been trying to move towards using SOC_foo
>> instead of ARCH_foo.  Any reason not to do that here also?
>> 
>> Kevin
>
> No reason, just wasn’t aware and no one said anything til now.  

Yeah, sorry for not reviewiing sooner.

> Hmm, how to handle this now, can we do this as a 3.16 cleanup?

Yes, we've already merged it, so doing it as a cleanup should be fine.

Thanks,

Kevin
