Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754617AbaCKHCI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 03:02:08 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:38920 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753355AbaCKHCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 03:02:06 -0400
Message-ID: <531EB4D8.6030207@converseincode.com>
Date: Tue, 11 Mar 2014 00:01:44 -0700
From: Behan Webster <behanw@converseincode.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: rostedt@goodmis.org, fweisbec@gmail.com, mingo@redhat.com,
        linux@arm.linux.org.uk, kpark3469@gmail.com
CC: keun-o.park@windriver.com, dave.martin@linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arm: LLVMLinux: use static inline in ARM ftrace.h
References: <1392949370-26422-1-git-send-email-behanw@converseincode.com>
In-Reply-To: <1392949370-26422-1-git-send-email-behanw@converseincode.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/20/14 18:22, behanw@converseincode.com wrote:
> From: Behan Webster <behanw@converseincode.com>
>
> With compilers which follow the C99 standard (like modern versions of gcc and
> clang), "extern inline" does the wrong thing (emits code for an externally
> linkable version of the inline function). In this case using static inline
> and removing the NULL version of return_address in return_address.c does
> the right thing.
Any input? Is it good as it is?

Behan

-- 
Behan Webster
behanw@converseincode.com

