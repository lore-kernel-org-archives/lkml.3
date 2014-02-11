Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752044AbaBKPPM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 10:15:12 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:40351 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015AbaBKPPI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 10:15:08 -0500
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 7.1 \(1827\))
Subject: Re: [PATCH v3 3/5] ARM: qcom: Split Qualcomm support into legacy and multiplatform
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <20140208032607.GC10784@codeaurora.org>
Date: Tue, 11 Feb 2014 09:13:23 -0600
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <392A0D29-65A3-403D-B645-DB74A1897170@codeaurora.org>
References: <1391725484-6673-1-git-send-email-galak@codeaurora.org> <1391725484-6673-4-git-send-email-galak@codeaurora.org> <20140208032607.GC10784@codeaurora.org>
To: Stephen Boyd <sboyd@codeaurora.org>
X-Mailer: Apple Mail (2.1827)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 7, 2014, at 9:26 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:

> On 02/06, Kumar Gala wrote:
>> diff --git a/arch/arm/mach-msm/platsmp.c b/arch/arm/mach-qcom/platsmp.c
>> similarity index 98%
>> rename from arch/arm/mach-msm/platsmp.c
>> rename to arch/arm/mach-qcom/platsmp.c
>> index 251a91e..67823a7 100644
>> --- a/arch/arm/mach-msm/platsmp.c
>> +++ b/arch/arm/mach-qcom/platsmp.c
>> @@ -2,6 +2,7 @@
>>  *  Copyright (C) 2002 ARM Ltd.
>>  *  All Rights Reserved
>>  *  Copyright (c) 2010, Code Aurora Forum. All rights reserved.
>> + *  Copyright (c) 2014 The Linux Foundation. All rights reserved.
> 
> We should replace the Code Aurora Forum copyright with Linux
> Foundation here.

Is this something we’ve been doing?  Its normally bad form to make such changes, but I don’t know what the details re when LF took over CAF w/regards to something like Copyright.

- k

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

