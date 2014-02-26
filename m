Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753543AbaBZRWy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 12:22:54 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:43869 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752913AbaBZRWw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 12:22:52 -0500
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 7.1 \(1827\))
Subject: Re: [PATCH 2/4] arm: qcom: Split Qualcomm support into legacy and multiplatform
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <7hha7m0x9w.fsf@paris.lan>
Date: Wed, 26 Feb 2014 11:22:47 -0600
Cc: linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <FF42247A-A4E8-4AA2-9C3B-BEEFC2F61714@codeaurora.org>
References: <1391107002-21470-1-git-send-email-galak@codeaurora.org> <1391107002-21470-3-git-send-email-galak@codeaurora.org> <7hha7m0x9w.fsf@paris.lan>
To: Kevin Hilman <khilman@linaro.org>
X-Mailer: Apple Mail (2.1827)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 26, 2014, at 8:22 AM, Kevin Hilman <khilman@linaro.org> wrote:

> Kumar Gala <galak@codeaurora.org> writes:
> 
>> Introduce a new mach-qcom that will support SoCs that intend to be
>> multiplatform compatiable while keeping mach-msm to legacy SoC/board
>> support that will not transition over to multiplatform.
>> 
>> As part of this, we move support for MSM8X60, MSM8960 and MSM8974 over
>> to mach-qcom.
>> 
>> Signed-off-by: Kumar Gala <galak@codeaurora.org>
> 
> Having a closer look at this after seeing the multi_v7_defconfig change,
> I have a minor nit on the new ARCH_QCOM name.
> 
> For new additions, we've been trying to move towards using SOC_foo
> instead of ARCH_foo.  Any reason not to do that here also?
> 
> Kevin

No reason, just wasn’t aware and no one said anything til now.  Hmm, how to handle this now, can we do this as a 3.16 cleanup?

- k

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

