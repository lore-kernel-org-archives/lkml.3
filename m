Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681AbbAXTiF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2015 14:38:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58401 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752845AbbAXTiD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2015 14:38:03 -0500
Message-ID: <54C3F489.2040504@redhat.com>
Date: Sat, 24 Jan 2015 14:37:45 -0500
From: "Carlos O'Donell" <carlos@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Daniel Church <dchurch@andplus.com>, Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org, libc-alpha@sourceware.org
Subject: Re: [PATCH v2 1/2] posix-timers: Prevents overrun counter overflow
References: <[PATCH 0/2] posix-timers: Prevents overrun counter overflow, adds DELAYTIMER_MAX> <1422121737-3686-1-git-send-email-dchurch@andplus.com> <1422121737-3686-2-git-send-email-dchurch@andplus.com>
In-Reply-To: <1422121737-3686-2-git-send-email-dchurch@andplus.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/24/2015 12:48 PM, Daniel Church wrote:
> +#define DELAYTIMER_MAX_DEFAULT 1000000

Why did you chose 1 million?

Have you reviewed what constant userspace, particularly glibc, is using?

Cheers,
Carlos.
