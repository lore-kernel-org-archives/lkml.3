Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753164AbaCGDJU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 22:09:20 -0500
Received: from mail-yh0-f47.google.com ([209.85.213.47]:43392 "EHLO
	mail-yh0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753128AbaCGDJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 22:09:18 -0500
MIME-Version: 1.0
In-Reply-To: <CAJvTdKneVk_ToJ=Sv4GnMfn5a0r=ynfL4fRLOoKHsqMrDYr8JA@mail.gmail.com>
References: <1393223377-5744-1-git-send-email-tuukka.tikkanen@linaro.org>
	<1393223377-5744-7-git-send-email-tuukka.tikkanen@linaro.org>
	<CAJvTdKneVk_ToJ=Sv4GnMfn5a0r=ynfL4fRLOoKHsqMrDYr8JA@mail.gmail.com>
Date: Thu, 6 Mar 2014 22:09:17 -0500
X-Google-Sender-Auth: U7kjK__8mE2GKjJG5vGVbLNKSmc
Message-ID: <CAJvTdKms3LNZfQ82CofNdtPKtFyEz6XtJGEfMWQDVLEvurkijw@mail.gmail.com>
Subject: Re: [PATCH 6/7] Cpuidle: Deal with timer expiring in the past
From: Len Brown <lenb@kernel.org>
To: Tuukka Tikkanen <tuukka.tikkanen@linaro.org>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NAK

tick_nohz_get_sleep_length() has exactly 1 consumer -- cpuidle.

Rather than have cpuidle second guess what is returned,
tick_nohz_get_sleep_length() should be updated to return a value
that makes sense to cpuidle.

thanks,
Len Brown, Intel Open Source Technology Cent
