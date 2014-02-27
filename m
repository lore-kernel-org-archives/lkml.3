Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752840AbaB0OMx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 09:12:53 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:46628 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500AbaB0OMv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 09:12:51 -0500
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 7.1 \(1827\))
Subject: Re: [PATCH] ARM: qcom: Enable basic support for Qualcomm platforms in multi_v7_defconfig
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <7hy50xv3rw.fsf@paris.lan>
Date: Thu, 27 Feb 2014 08:12:47 -0600
Cc: linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <0C19AFF2-3CC6-476A-AE82-DBF161971AE2@codeaurora.org>
References: <1393360445-16923-1-git-send-email-galak@codeaurora.org> <7hy50xv3rw.fsf@paris.lan>
To: Kevin Hilman <khilman@linaro.org>
X-Mailer: Apple Mail (2.1827)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 26, 2014, at 5:43 PM, Kevin Hilman <khilman@linaro.org> wrote:

> Kumar Gala <galak@codeaurora.org> writes:
> 
>> Enable support for the MSM8x60, MSM8960, and MSM8974 SoCs, clocks and
>> serial console as part of the standard multi_v7_defconfig.
>> 
>> Signed-off-by: Kumar Gala <galak@codeaurora.org>
>> ---
>> 
>> I leave this to the arm-soc guys to apply because of possible conflicts
>> with other updates to multi_v7_defconfig.
> 
> Seem to be a handful of !qcom changes here, probably resulting from a
> run of 'make savedefconfig' without all the new changes in.
> 
> I've thinned this out to only the qcom changes and applied the following
> to next/boards.  I think it's better to do any 'make savedefconfig'
> cleanups as a separate, cleanup-only patch as needed.
> 
> Kevin

I had it as two separate patches in my tree, but merged before sending, wasn’t sure how defconfig updates where desired.  Will do so in the future.

Now if you guys can just merge the 'qcom-dt-for-3.15’ pull request ;)

- k

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

