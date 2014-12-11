Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754905AbaLKTAs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 14:00:48 -0500
Received: from mail-la0-f49.google.com ([209.85.215.49]:50134 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381AbaLKTAq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 14:00:46 -0500
Message-ID: <5489E9DA.8000504@cogentembedded.com>
Date: Thu, 11 Dec 2014 22:00:42 +0300
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Mark Salter <msalter@redhat.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
CC: Sonny Rao <sonnyrao@chromium.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: arm64 hitting BUG in arch_timer.h
References: <1418245000.23374.26.camel@t520.localdomain>
In-Reply-To: <1418245000.23374.26.camel@t520.localdomain>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 12/10/2014 11:56 PM, Mark Salter wrote:

> Using Linus' tree from this morning, I am hitting:

>     [    0.000000] BUG: failure at ./arch/arm64/include/asm/arch_timer.h:112/arch_counter_get_cntpct!

> This is triggered by commit 0b46b8a718 ("clocksource: arch_timer: Fix
> code to use physical timers when requested") which addresses an armv7
> problem. Arm64 wants to always use a virtual timer. I used this to avoid
> the BUG and get a booting kernel:

    You didn't sign off on the patch, so it can't be applied.

[...]

WBR, Sergei

