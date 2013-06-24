Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751912Ab3FXUKi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 16:10:38 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:49624 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006Ab3FXUKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 16:10:37 -0400
Date: Mon, 24 Jun 2013 13:10:35 -0700
From: David Brown <davidb@codeaurora.org>
To: Stephen Boyd <sboyd@codeaurora.org>, Chris Ball <cjb@laptop.org>
Cc: Daniel Walker <dwalker@fifo99.com>, Bryan Huntsman <bryanh@codeaurora.org>,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Saravana Kannan <skannan@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: Re: [PATCH/RESEND 00/12] Convert MSM to common clock framework
Message-ID: <20130624201034.GA23147@codeaurora.org>
References: <1371490999-15501-1-git-send-email-sboyd@codeaurora.org>
 <20130621012952.GE6300@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20130621012952.GE6300@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 20, 2013 at 06:29:52PM -0700, Stephen Boyd wrote:
>On 06/17, Stephen Boyd wrote:
>> Resending to collect higher level maintainer acks per Olof's request.
>> The plan is to push this patchset through MSM to the arm-soc tree.
>>
>> This patchset moves the existing MSM clock code and affected drivers to the
>> common clock framework. A prerequisite of moving to the common clock
>> framework is to use clk_prepare() and clk_enable() so the first
>> few patches migrate drivers to that call (clk_prepare() is a no-op on MSM
>> right now). It also removes some custom clock APIs that MSM provides
>> and finally moves the proc_comm clock code to the common struct clk.
>>
>> This patch series will be used as the foundation of the MSM 8660/8960
>> clock code that I plan to send out after this series.
>>
>
>David, can you pick this up and send it off to arm-soc now?

I'm still not seeing an Ack from

  msm_sdcc: Convert to clk_prepare/unprepare

Thanks,
David

-- 
sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
