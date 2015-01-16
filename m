Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754392AbbAPLQM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 06:16:12 -0500
Received: from borg.tf-network.de ([62.75.218.204]:56065 "EHLO
	borg.tf-network.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598AbbAPLQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 06:16:09 -0500
Message-ID: <54B8F2F5.8020601@whissi.de>
Date: Fri, 16 Jan 2015 12:16:05 +0100
From: "Thomas D." <whissi@whissi.de>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "x86@kernel.org" <x86@kernel.org>,
        Vivek Goyal <vgoyal@redhat.com>, Jan Beulich <JBeulich@suse.com>,
        Junjie Mao <eternal.n08@gmail.com>, Andi Kleen <ak@linux.intel.com>,
        Baoquan He <bhe@redhat.com>
Subject: Re: [PATCH] x86, boot: skip relocs when load address unchanged
References: <20150116005146.GA4212@www.outflux.net>
In-Reply-To: <20150116005146.GA4212@www.outflux.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Kees Cook wrote:
> This is a reimplementation of Baoquan's "kaslr: check if kernel location is
> changed", which performs the check without needing to change the function
> declaration. This should have exactly the same effect, but I dropped Vivek's
> Ack and Thomas's Test, since it's technically a different patch.

Your patch works for me, too.

Tested with linux-3.19-rc4 on a 64-bit system.

Thanks!


-Thomas


