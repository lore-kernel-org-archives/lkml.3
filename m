Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752975Ab3KKUIA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 15:08:00 -0500
Received: from mail-ee0-f49.google.com ([74.125.83.49]:35950 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752726Ab3KKUHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 15:07:52 -0500
Date: Mon, 11 Nov 2013 21:07:49 +0100
From: Ingo Molnar <mingo@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Kees Cook <keescook@chromium.org>, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Subject: Re: [tip:x86/kaslr] x86, kaslr: Provide randomness functions
Message-ID: <20131111200748.GB17408@gmail.com>
References: <1381450698-28710-4-git-send-email-keescook@chromium.org>
 <tip-5bfce5ef55cbe78ee2ee6e97f2e26a8a582008f3@git.kernel.org>
 <20131111182046.GA14961@gmail.com>
 <20131111183101.GA16051@gmail.com>
 <CAGXu5jL96B4+McO=K9dptu81m+bdKWOZ8YS9x7+SZxkjfUsg9Q@mail.gmail.com>
 <528131E7.2060509@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <528131E7.2060509@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

> Of course, perhaps we could just hash struct boot_params as a starting 
> point?

Yeah, that would be a good first step, before trying to parse DMI or ACPI. 
Anything that is reasonably system dependent and gives at least some 
amount of unpredicability.

Thanks,

	Ingo
