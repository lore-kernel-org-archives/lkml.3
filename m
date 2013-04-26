Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757409Ab3DZWTX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 18:19:23 -0400
Received: from mail.skyhub.de ([78.46.96.112]:49334 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752540Ab3DZWTW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 18:19:22 -0400
Date: Sat, 27 Apr 2013 00:19:15 +0200
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org,
        kernel-hardening@lists.openwall.com,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, Jarkko Sakkinen <jarkko.sakkinen@intel.com>,
        Matthew Garrett <mjg@redhat.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Eric Northup <digitaleric@google.com>,
        Dan Rosenberg <drosenberg@vsecurity.com>,
        Julien Tinnes <jln@google.com>, Will Drewry <wad@chromium.org>
Subject: Re: [PATCH 6/6] x86: kaslr: report kernel offset on panic
Message-ID: <20130426221915.GB26059@pd.tnic>
References: <1367003005-5560-7-git-send-email-keescook@chromium.org>
 <20130426221301.GA26059@pd.tnic>
 <517AFC6E.4020800@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <517AFC6E.4020800@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 26, 2013 at 03:15:10PM -0700, H. Peter Anvin wrote:
> That really makes it harder to figure out what the heck the register
> content may mean...

So we need a goddam script to massage oopses now, if kaslr is enabled.

:-(

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
