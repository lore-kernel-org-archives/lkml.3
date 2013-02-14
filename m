Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761519Ab3BNR6A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 12:58:00 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:51486 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758307Ab3BNR56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 12:57:58 -0500
Message-ID: <511D25A3.80604@linaro.org>
Date: Thu, 14 Feb 2013 09:57:55 -0800
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, mingo@kernel.org, hpa@zytor.com,
        john.stultz@linaro.org, tglx@linutronix.de
CC: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:core/locking] ntp: Make ntp_lock raw.
References: <tip-5736e12e227c8c039744ae1f3b05de91a2353892@git.kernel.org>
In-Reply-To: <tip-5736e12e227c8c039744ae1f3b05de91a2353892@git.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/14/2013 09:55 AM, tip-bot for Thomas Gleixner wrote:
> Commit-ID:  5736e12e227c8c039744ae1f3b05de91a2353892
> Gitweb:     http://git.kernel.org/tip/5736e12e227c8c039744ae1f3b05de91a2353892
> Author:     Thomas Gleixner <tglx@linutronix.de>
> AuthorDate: Tue, 10 Apr 2012 11:14:55 +0200
> Committer:  Thomas Gleixner <tglx@linutronix.de>
> CommitDate: Thu, 14 Feb 2013 18:39:06 +0100
>
> ntp: Make ntp_lock raw.
>
> seconds_overflow() is called from hard interrupt context even on
> Preempt-RT. This requires the lock to be a raw_spinlock.
>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: John Stultz <john.stultz@linaro.org>

Acked-by: John Stultz <john.stultz@linaro.org>

