Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754031Ab3H1Au1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 20:50:27 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:56934 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753051Ab3H1AuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 20:50:25 -0400
Message-ID: <521D494F.1010507@codeaurora.org>
Date: Tue, 27 Aug 2013 17:50:23 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: akpm@linux-foundation.org
CC: mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-next@vger.kernel.org, voice.shen@atmel.com,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: mmotm 2013-08-27-16-51 uploaded
References: <20130827235227.99DB95A41D6@corp2gmr1-2.hot.corp.google.com>
In-Reply-To: <20130827235227.99DB95A41D6@corp2gmr1-2.hot.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/27/13 16:52, akpm@linux-foundation.org wrote:
> * kernel-time-sched_clockc-correct-the-comparison-parameter-of-mhz.patch
>

I believe Russell nacked this change[1]? This should probably be dropped
unless there's been more discussion. Or maybe reworked into a comment in
the code that doesn't lead to the same change again.

[1] https://lkml.org/lkml/2013/8/7/95

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

