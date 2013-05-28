Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756184Ab3E1UeW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 16:34:22 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:37458 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755835Ab3E1UeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 16:34:21 -0400
Message-ID: <51A514CB.7090808@linaro.org>
Date: Tue, 28 May 2013 13:34:19 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Baruch Siach <baruch@tkos.co.il>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Jamie Iles <jamie@jamieiles.com>,
        Dinh Nguyen <dinguyen@altera.com>
Subject: Re: [PATCH 1/2] clocksource: dw_apb: remove unused header
References: <1369570367-994-1-git-send-email-baruch@tkos.co.il>
In-Reply-To: <1369570367-994-1-git-send-email-baruch@tkos.co.il>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/26/2013 05:12 AM, Baruch Siach wrote:
> The time.h header seems not to be used by current code. Removing this include
> allows the driver to build on other architecture that do not have this header.
>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: John Stultz <john.stultz@linaro.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Jamie Iles <jamie@jamieiles.com>
> Cc: Dinh Nguyen <dinguyen@altera.com>
> Signed-off-by: Baruch Siach <baruch@tkos.co.il>
> ---
I've gone ahead and queued this for 3.11

thanks
-john

