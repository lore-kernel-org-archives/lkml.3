Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752128AbaBZDCS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 22:02:18 -0500
Received: from mail-pb0-f49.google.com ([209.85.160.49]:42959 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399AbaBZDCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 22:02:17 -0500
Message-ID: <530D5935.9010104@mit.edu>
Date: Tue, 25 Feb 2014 19:02:13 -0800
From: Andy Lutomirski <luto@amacapital.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>
CC: John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Anton Vorontsov <anton@enomsg.org>,
        Alexey Perevalov <a.perevalov@samsung.com>, kyungmin.park@samsung.com,
        cw00.choi@samsung.com
Subject: Re: [RFC patch 0/5] hrtimers: Add deferrable mode
References: <20140221173936.583477951@linutronix.de>
In-Reply-To: <20140221173936.583477951@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/21/2014 09:56 AM, Thomas Gleixner wrote:
> Deferrable timers are beneficial for power saving. They behave like
> standard timers except that their expiry can be delayed up to the
> expiry of the next non deferred timer. That prevents them from waking
> up cpus from deep idle periods.

What does this accomplish that can't be done with hrtimers with enormous
slack?

--Andy
