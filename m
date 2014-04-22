Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758560AbaDVUlS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 16:41:18 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53627 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757107AbaDVUlP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 16:41:15 -0400
Message-ID: <5356D3E7.40009@linaro.org>
Date: Tue, 22 Apr 2014 13:41:11 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] sched_clock: Remove deprecated setup_sched_clock() API
References: <1397003599-22386-1-git-send-email-sboyd@codeaurora.org>
In-Reply-To: <1397003599-22386-1-git-send-email-sboyd@codeaurora.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/2014 05:33 PM, Stephen Boyd wrote:
> Remove the 32-bit only setup_sched_clock() API now that all users
> have been converted to the 64-bit friendly sched_clock_register().
>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>

Got this queued for 3.16. Thanks!
-john

