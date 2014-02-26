Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752139AbaBZOWJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 09:22:09 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:51197 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751897AbaBZOWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 09:22:06 -0500
From: Kevin Hilman <khilman@linaro.org>
To: Kumar Gala <galak@codeaurora.org>
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] arm: qcom: Split Qualcomm support into legacy and multiplatform
References: <1391107002-21470-1-git-send-email-galak@codeaurora.org>
	<1391107002-21470-3-git-send-email-galak@codeaurora.org>
Date: Wed, 26 Feb 2014 06:22:03 -0800
In-Reply-To: <1391107002-21470-3-git-send-email-galak@codeaurora.org> (Kumar
	Gala's message of "Thu, 30 Jan 2014 12:36:40 -0600")
Message-ID: <7hha7m0x9w.fsf@paris.lan>
User-Agent: Gnus/5.130008 (Ma Gnus v0.8) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kumar Gala <galak@codeaurora.org> writes:

> Introduce a new mach-qcom that will support SoCs that intend to be
> multiplatform compatiable while keeping mach-msm to legacy SoC/board
> support that will not transition over to multiplatform.
>
> As part of this, we move support for MSM8X60, MSM8960 and MSM8974 over
> to mach-qcom.
>
> Signed-off-by: Kumar Gala <galak@codeaurora.org>

Having a closer look at this after seeing the multi_v7_defconfig change,
I have a minor nit on the new ARCH_QCOM name.

For new additions, we've been trying to move towards using SOC_foo
instead of ARCH_foo.  Any reason not to do that here also?

Kevin
