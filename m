Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932912AbbAIKlV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 05:41:21 -0500
Received: from mail.skyhub.de ([78.46.96.112]:58299 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932290AbbAIKlT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 05:41:19 -0500
Date: Fri, 9 Jan 2015 11:41:17 +0100
From: Borislav Petkov <bp@alien8.de>
To: Denys Vlasenko <dvlasenk@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Frederic Weisbecker <fweisbec@gmail.com>, X86 ML <x86@kernel.org>,
        Alexei Starovoitov <ast@plumgrid.com>, Will Drewry <wad@chromium.org>,
        Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH 2/4] x86: ia32entry.S: fix wrong symbolic constant usage:
 R11->ARGOFFSET
Message-ID: <20150109104117.GB13637@pd.tnic>
References: <1420734315-30943-1-git-send-email-dvlasenk@redhat.com>
 <1420734315-30943-3-git-send-email-dvlasenk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1420734315-30943-3-git-send-email-dvlasenk@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 08, 2015 at 05:25:13PM +0100, Denys Vlasenko wrote:
> The values of these two constants are the same, the meaning is different.
> 
> Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>
> CC: Linus Torvalds <torvalds@linux-foundation.org>
> CC: Oleg Nesterov <oleg@redhat.com>
> CC: "H. Peter Anvin" <hpa@zytor.com>
> CC: Andy Lutomirski <luto@amacapital.net>
> CC: Frederic Weisbecker <fweisbec@gmail.com>
> CC: X86 ML <x86@kernel.org>
> CC: Alexei Starovoitov <ast@plumgrid.com>
> CC: Will Drewry <wad@chromium.org>
> CC: Kees Cook <keescook@chromium.org>
> CC: linux-kernel@vger.kernel.org
> ---

Acked-by: Borislav Petkov <bp@suse.de>

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
