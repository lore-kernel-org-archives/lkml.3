Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755929AbaKRTo2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 14:44:28 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:48266 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755710AbaKRTnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 14:43:21 -0500
Message-ID: <546BA158.6080900@codeaurora.org>
Date: Tue, 18 Nov 2014 11:43:20 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Will Deacon <will.deacon@arm.com>,
        Rob Clark <robdclark@gmail.com>
Subject: Re: linux-next: build warning after merge of the arm tree
References: <20141118192507.39f68bb7@canb.auug.org.au> <546B9696.4030703@codeaurora.org> <20141118192103.GF4042@n2100.arm.linux.org.uk>
In-Reply-To: <20141118192103.GF4042@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2014 11:21 AM, Russell King - ARM Linux wrote:
> On Tue, Nov 18, 2014 at 10:57:26AM -0800, Stephen Boyd wrote:
>> Urgh, I thought I fixed that but I guess I only took care of not
>> assigning it unless we actually need it. Well we can do the #ifdef
>> thing, or move to IS_ENABLED. Here's both options.
> I'd prefer the first as it increases compiler coverage.
>
> Thanks.
>

Ok I'll ship it into your patch system in a little bit with some real
commit text.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project

