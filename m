Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754062Ab3FQSHc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 14:07:32 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:44099 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752127Ab3FQSHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 14:07:31 -0400
Date: Mon, 17 Jun 2013 11:07:28 -0700
From: David Brown <davidb@codeaurora.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Stephen Boyd <sboyd@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH/RESEND 01/12] msm_serial: Convert to clk_prepare/unprepare
Message-ID: <20130617180728.GA21158@codeaurora.org>
References: <1371490999-15501-1-git-send-email-sboyd@codeaurora.org>
 <1371490999-15501-2-git-send-email-sboyd@codeaurora.org>
 <20130617175510.GA15370@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20130617175510.GA15370@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 17, 2013 at 10:55:10AM -0700, Greg Kroah-Hartman wrote:
>On Mon, Jun 17, 2013 at 10:43:08AM -0700, Stephen Boyd wrote:
>> Add calls to clk_prepare and unprepare so that MSM can migrate to
>> the common clock framework.
>>
>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
>
>Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>
>Or do you want me to take the serial ones through my tree?  It's your
>choice, either is fine for me.

I can go ahead and pull them through the MSM tree.

Thanks,
David

-- 
sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
