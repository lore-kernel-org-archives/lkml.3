Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752737AbaGKK2z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 06:28:55 -0400
Received: from mail.skyhub.de ([78.46.96.112]:44546 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751352AbaGKK2y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 06:28:54 -0400
Date: Fri, 11 Jul 2014 12:28:44 +0200
From: Borislav Petkov <bp@alien8.de>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, X86 ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: Get rid of __HAVE_ARCH_CMPXCHG
Message-ID: <20140711102844.GA17147@pd.tnic>
References: <1405072301-8719-1-git-send-email-bp@alien8.de>
 <CAMuHMdXz9dYaWizBo1hxuPx_-Y40tx+TfzuTihR6BySU6a+3qw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAMuHMdXz9dYaWizBo1hxuPx_-Y40tx+TfzuTihR6BySU6a+3qw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2014 at 12:19:43PM +0200, Geert Uytterhoeven wrote:
> What about non-x86? __HAVE_ARCH_CMPXCHG isn't always defined.

Bah, this hunk was definitely not supposed to be there. Thanks for the
catch!

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
