Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934553Ab3GRXRP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 19:17:15 -0400
Received: from mail-ve0-f178.google.com ([209.85.128.178]:56334 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932828Ab3GRXRO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 19:17:14 -0400
MIME-Version: 1.0
In-Reply-To: <20130718230312.GA22348@www.outflux.net>
References: <20130718230312.GA22348@www.outflux.net>
Date: Thu, 18 Jul 2013 16:17:12 -0700
Message-ID: <CA+8MBb+i+kmnAMi4dTEX9nGwMLRz0EUz0tY0N7YA2btFEtgmQw@mail.gmail.com>
Subject: Re: [PATCH] panic: call panic handlers before kmsg_dump
From: Tony Luck <tony.luck@gmail.com>
To: Kees Cook <keescook@chromium.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Vorontsov <anton@enomsg.org>, Colin Cross <ccross@android.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Vikram Mulukutla <markivx@codeaurora.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Rusty Russell <rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 18, 2013 at 4:03 PM, Kees Cook <keescook@chromium.org> wrote:
> Since the panic handlers may produce additional information (via printk)
> for the kernel log, it should be reported as part of the panic output
> saved by kmsg_dump(). Without this re-ordering, nothing that adds
> information to a panic will show up in pstore's view when kmsg_dump
> runs, and is therefore not visible to crash reporting tools that examine
> pstore output.

Good point.

Acked-by: Tony Luck <tony.luck@intel.com>
