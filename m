Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752650AbaKXLjo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 06:39:44 -0500
Received: from mail.skyhub.de ([78.46.96.112]:41341 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752576AbaKXLjm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 06:39:42 -0500
Date: Mon, 24 Nov 2014 12:39:40 +0100
From: Borislav Petkov <bp@alien8.de>
To: Andy Lutomirski <luto@amacapital.net>
Cc: x86@kernel.org, Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Oleg Nesterov <oleg@redhat.com>, Tony Luck <tony.luck@intel.com>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH v4 4/5] x86: Clean up current_stack_pointer
Message-ID: <20141124113940.GB20296@pd.tnic>
References: <cover.1416604491.git.luto@amacapital.net>
 <e771b0f24aaff5d3ed8d8934e202c7a7f9c54526.1416604491.git.luto@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <e771b0f24aaff5d3ed8d8934e202c7a7f9c54526.1416604491.git.luto@amacapital.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 21, 2014 at 01:26:10PM -0800, Andy Lutomirski wrote:
> There's no good reason for it to be a macro, and x86_64 will want to
> use it, so it should be in a header.
> 
> Signed-off-by: Andy Lutomirski <luto@amacapital.net>

Acked-by: Borislav Petkov <bp@suse.de>

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
