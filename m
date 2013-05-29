Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966320Ab3E2T1N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 15:27:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49802 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965341Ab3E2T1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 15:27:08 -0400
Date: Wed, 29 May 2013 12:27:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Derek Basehore <dbasehore@chromium.org>
Cc: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
        Alessandro Zummo <a.zummo@towertech.it>, rostedt@goodmis.org,
        gregkh@linuxfoundation.org
Subject: Re: [PATCH] rtc: cmos: Fix accidentally enabling rtc channel
Message-Id: <20130529122707.997236928e9f87dc6ba2eaa7@linux-foundation.org>
In-Reply-To: <1369271045-17410-1-git-send-email-dbasehore@chromium.org>
References: <1369271045-17410-1-git-send-email-dbasehore@chromium.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 May 2013 18:04:05 -0700 Derek Basehore <dbasehore@chromium.org> wrote:

> During resume, we call hpet_rtc_timer_init after masking an irq bit in hpet.
> This will cause the call to hpet_disable_rtc_channel to be undone if RTC_AIE is
> the only bit not masked.

What were the user-visible runtime effects of this bug?
