Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932928AbaKRVb1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 16:31:27 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:57341 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932494AbaKRVbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 16:31:24 -0500
Message-ID: <546BBAAA.4050909@codeaurora.org>
Date: Tue, 18 Nov 2014 13:31:22 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-next@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>, Rob Clark <robdclark@gmail.com>
Subject: Re: [PATCH] ARM: vfp: Silence mvfr0 unused variable warning
References: <1416344191-20484-1-git-send-email-sboyd@codeaurora.org> <20141119081438.3df66238@canb.auug.org.au>
In-Reply-To: <20141119081438.3df66238@canb.auug.org.au>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2014 01:14 PM, Stephen Rothwell wrote:
> One small nit below:
>> +		if (IS_ENABLED(CONFIG_VFPv3)) {
>> +			mvfr0 = fmrx(MVFR0);
> Now that you have a block here, you could move the declaration of mvfr0
> into this block, right?
>

Sure I can squash in that change.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project

