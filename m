Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753473AbaE0SyI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 14:54:08 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:36491 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753224AbaE0SyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 14:54:04 -0400
Message-ID: <5384DF47.2070904@codeaurora.org>
Date: Tue, 27 May 2014 11:53:59 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-arm-kernel@lists.infradead.org, Corey Minyard <cminyard@mvista.com>,
        linux-kernel@vger.kernel.org, Stanislav Meduna <stano@meduna.org>,
        minyard@acm.org, linux-rt-users@vger.kernel.org
Subject: Re: [PATCH] arm: Set hardirq tracing to on when idling
References: <1401045323-7116-1-git-send-email-minyard@acm.org> <4559339.apo3Fd10HK@wuerfel> <5384BF89.6010509@meduna.org> <4475199.26Fs5MKAfh@wuerfel>
In-Reply-To: <4475199.26Fs5MKAfh@wuerfel>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/27/14 11:49, Arnd Bergmann wrote:
>
> You also commented in that thread about stop_critical_timings()/
> start_critical_timings(). Corey, can you look at that, too? I
> think it's designed to avoid the issue you are seeing but
> for some reason doesn't.

I sent a patch last week to "solve" this problem. I'm not sure if it's
right but it works for me.

https://lkml.org/lkml/2014/5/19/607

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

