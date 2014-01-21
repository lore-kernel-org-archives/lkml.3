Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754890AbaAUP2K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 10:28:10 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:49701 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754134AbaAUP2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 10:28:09 -0500
Message-ID: <52DE9206.1000402@codeaurora.org>
Date: Tue, 21 Jan 2014 10:28:06 -0500
From: Christopher Covington <cov@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>
CC: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: Make pgtbl macro more robust
References: <1389015593-31716-1-git-send-email-cov@codeaurora.org> <20140117185029.GC13785@codeaurora.org>
In-Reply-To: <20140117185029.GC13785@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/17/2014 01:50 PM, Stephen Boyd wrote:
> On 01/06, Christopher Covington wrote:
>> The pgtbl macro couldn't handle the specific
>> (TEXT_OFFSET - PG_DIR_SIZE) value that the combination of
>> MSM platforms and LPAE created:
>>
>> head.S:163: Error: invalid constant (203000) after fixup
>>
>> Regardless of whether this combination of configuration options
>> will work on currently support platforms at run time, make it
>> at least assemble properly.
>>
>> Signed-off-by: Christopher Covington <cov@codeaurora.org>
> 
> Looks good to me.
> 
> Reviewed-by: Stephen Boyd <sboyd@codeaurora.org>
> 
> I think you can put it in the patch tracker. Russell?

Added as

http://www.arm.linux.org.uk/developer/patches/viewpatch.php?id=7947/1

Regards,
Christopher

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by the Linux Foundation.
