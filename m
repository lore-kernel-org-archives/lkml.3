Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752325Ab3JDG0t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 02:26:49 -0400
Received: from mail-ea0-f170.google.com ([209.85.215.170]:39314 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880Ab3JDG0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 02:26:47 -0400
Date: Fri, 4 Oct 2013 08:26:44 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Stephen Warren <swarren@wwwdotorg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephen Warren <swarren@nvidia.com>,
        Thomas Gleixner <tglx@linutronix.de>, Tom Gundersen <teg@jklm.no>,
        David Herrmann <dh.herrmann@gmail.com>,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86/simplefb: Fix overflow causing bogus
 fall-back
Message-ID: <20131004062644.GE11399@gmail.com>
References: <1380644320-1026-1-git-send-email-teg@jklm.no>
 <tip-e33a29a5ae711162c6b6fefc0a2ef18f4a4254bf@git.kernel.org>
 <CAMuHMdV-fJ2F6Hus7CgUyCda6et7eR5Z2osZp-0MnWKrSwM+6w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdV-fJ2F6Hus7CgUyCda6et7eR5Z2osZp-0MnWKrSwM+6w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Geert Uytterhoeven <geert@linux-m68k.org> wrote:

> On Thu, Oct 3, 2013 at 3:59 PM, tip-bot for Tom Gundersen
> <tipbot@zytor.com> wrote:
> > On my MacBook Air lfb_size is 4M, which makes the bitshit
> 
> bitshift?

LOL!

Thanks,

	Ingo
