Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751937AbaBKSK0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 13:10:26 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:33980 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689AbaBKSKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 13:10:23 -0500
Message-ID: <52FA678C.6050000@codeaurora.org>
Date: Tue, 11 Feb 2014 10:10:20 -0800
From: Bryan Huntsman <bryanh@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Kumar Gala <galak@codeaurora.org>
CC: Stephen Boyd <sboyd@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 3/5] ARM: qcom: Split Qualcomm support into legacy
 and multiplatform
References: <1391725484-6673-1-git-send-email-galak@codeaurora.org> <1391725484-6673-4-git-send-email-galak@codeaurora.org> <20140208032607.GC10784@codeaurora.org> <392A0D29-65A3-403D-B645-DB74A1897170@codeaurora.org>
In-Reply-To: <392A0D29-65A3-403D-B645-DB74A1897170@codeaurora.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/11/2014 07:13 AM, Kumar Gala wrote:
>>>  *  Copyright (c) 2010, Code Aurora Forum. All rights reserved.
>>> >> + *  Copyright (c) 2014 The Linux Foundation. All rights reserved.
>> > 
>> > We should replace the Code Aurora Forum copyright with Linux
>> > Foundation here.
> Is this something we’ve been doing?  Its normally bad form to make such changes, but I don’t know what the details re when LF took over CAF w/regards to something like Copyright.
> 
> - k

Yes, the line should read:

- *  Copyright (c) 2010, Code Aurora Forum. All rights reserved.
+ *  Copyright (c) 2010,2014 The Linux Foundation. All rights reserved.

-- 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
