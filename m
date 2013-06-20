Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965160Ab3FTMBE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 08:01:04 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:48952 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753085Ab3FTMBB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 08:01:01 -0400
Date: Thu, 20 Jun 2013 14:00:55 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Michel Lespinasse <walken@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH] x86: fix trigger_all_cpu_backtrace() implementation
Message-ID: <20130620120055.GC12479@gmail.com>
References: <1370518875-1346-1-git-send-email-walken@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370518875-1346-1-git-send-email-walken@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Michel Lespinasse <walken@google.com> wrote:

> The following change fixes the x86 implementation of
> trigger_all_cpu_backtrace(), which was previously (accidentally, as
> far as I can tell) disabled to always return false as on architectures
> that do not implement this function.
> 
> Is there any chance that we could get this in before v3.10 ?

Looks good at first glance - I'll test it and push Linuswards.

Thanks,

	Ingo
