Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752660Ab3FQU02 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 16:26:28 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:53617 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453Ab3FQU00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 16:26:26 -0400
Date: Mon, 17 Jun 2013 13:26:24 -0700
From: David Brown <davidb@codeaurora.org>
To: Olof Johansson <olof@lixom.net>
Cc: arm@kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <rmk@arm.linux.org.uk>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL 2/3] msm fixes for 3.11
Message-ID: <20130617202624.GA23915@codeaurora.org>
References: <1371232615-30731-1-git-send-email-davidb@codeaurora.org>
 <1371232615-30731-4-git-send-email-davidb@codeaurora.org>
 <20130615012617.GU18124@quad.lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20130615012617.GU18124@quad.lixom.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 14, 2013 at 06:26:17PM -0700, Olof Johansson wrote:

>> Stephen Boyd (3):
>>       ARM: dts: msm: Fix bad register addresses
>
>Hmm. I see that the msm-hsuart device nodes completely lack reg entries. That's
>considerably more important to fix than the cosmetic unit address that's not
>even needed unless two nodes happen to have the same name.

I'm not seeing the missing reg entries in anyone's tree.

However, it appears that both of us resolved the merge conflict
differently, and both did it incorrectly.

How would you like this to be fixed?  Should I just send you a patch
based off of the current soc tree?

Thanks,
David

-- 
sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
