Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762886Ab3EDALD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 20:11:03 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:49451 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756356Ab3EDALB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 20:11:01 -0400
Message-ID: <51845212.2060500@linaro.org>
Date: Fri, 03 May 2013 17:10:58 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ntp: Remove unused variable flags in __hardpps
References: <1367616427-4223-1-git-send-email-geert@linux-m68k.org>
In-Reply-To: <1367616427-4223-1-git-send-email-geert@linux-m68k.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/03/2013 02:27 PM, Geert Uytterhoeven wrote:
> kernel/time/ntp.c: In function ‘__hardpps’:
> kernel/time/ntp.c:877: warning: unused variable ‘flags’
>
> commit a076b2146fabb0894cae5e0189a8ba3f1502d737 ("ntp: Remove ntp_lock,
> using the timekeeping locks to protect ntp state") removed its users,
> but not the actual variable.
>
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

Thanks for catching this!

Acked-by: John Stultz <john.stultz@linaro.org>

