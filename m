Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752689AbaB1AWm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 19:22:42 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:59821 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999AbaB1AWk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 19:22:40 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Subject: Re: [PATCH 3/3] ARM: config: Update msm_defconfig
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <20140227221458.GA5334@codeaurora.org>
Date: Thu, 27 Feb 2014 18:22:37 -0600
Cc: Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org
Content-Transfer-Encoding: 8BIT
Message-Id: <318973D9-95B5-4D53-B774-D4239FD9AECB@codeaurora.org>
References: <1393467394-10907-1-git-send-email-sboyd@codeaurora.org> <1393467394-10907-4-git-send-email-sboyd@codeaurora.org> <20140227221458.GA5334@codeaurora.org>
To: David Brown <davidb@codeaurora.org>
X-Mailer: Apple Mail (2.1874)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 27, 2014, at 4:14 PM, David Brown <davidb@codeaurora.org> wrote:

> On Wed, Feb 26, 2014 at 06:16:34PM -0800, Stephen Boyd wrote:
>> Now that DT based platforms are split out of mach-msm into
>> mach-qcom, put back a non-DT based SoC into the msm_defconfig and
>> stop selecting unsupported drivers.
>> 
>> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
>> ---
>> arch/arm/configs/msm_defconfig | 25 +++----------------------
>> 1 file changed, 3 insertions(+), 22 deletions(-)
> 
> Acked-by: David Brown <davidb@codeaurora.org>
> 
> Kumar, can you just pull this in with the other qcom changes from
> Sephen?

sure

- k

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

