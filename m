Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755890AbaIZOER (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 10:04:17 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:55268 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755218AbaIZOEM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 10:04:12 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: [PATCH 2/2] soc/fsl: add ftm alarm driver for ls1021a platform
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <1411714121-32138-2-git-send-email-dongsheng.wang@freescale.com>
Date: Fri, 26 Sep 2014 09:04:08 -0500
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Sandeep Nair <sandeep_n@ti.com>, Olof Johansson <olof@lixom.net>,
        shawn.guo@linaro.org, Greg KH <gregkh@linuxfoundation.org>,
        Paul Walmsley <paul@pwsan.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org, shawn.guo@freescale.com
Content-Transfer-Encoding: 8BIT
Message-Id: <B448818B-E208-4451-8BA0-53D53E4BB7FC@codeaurora.org>
References: <1411714121-32138-1-git-send-email-dongsheng.wang@freescale.com> <1411714121-32138-2-git-send-email-dongsheng.wang@freescale.com>
To: Dongsheng Wang <dongsheng.wang@freescale.com>
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 26, 2014, at 1:48 AM, Dongsheng Wang <dongsheng.wang@freescale.com> wrote:

> From: Wang Dongsheng <dongsheng.wang@freescale.com>
> 
> Only Ftm0 can be used when system going to deep sleep. So this driver
> to support ftm0 as a wakeup source.
> 
> Signed-off-by: Wang Dongsheng <dongsheng.wang@freescale.com>

How does this differ from drivers/clocksource/fsl_ftm_timer.c

Why not extend that with the alarm functionality you need?

Also, where is the DT binding spec for this (if you plan on having a separate driver)?

- k

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

