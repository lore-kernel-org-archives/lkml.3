Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754921Ab3FPDO1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 23:14:27 -0400
Received: from ozlabs.org ([203.10.76.45]:56033 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754784Ab3FPDOZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 23:14:25 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Mathias Krause <minipli@googlemail.com>
Cc: Mathias Krause <minipli@googlemail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] module: don't modify argument of module_kallsyms_lookup_name()
In-Reply-To: <1371258778-12655-1-git-send-email-minipli@googlemail.com>
References: <1371258778-12655-1-git-send-email-minipli@googlemail.com>
User-Agent: Notmuch/0.15.2+81~gd2c8818 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Sun, 16 Jun 2013 12:05:16 +0930
Message-ID: <87fvwirdej.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathias Krause <minipli@googlemail.com> writes:
> If we pass a pointer to a const string in the form "module:symbol"
> module_kallsyms_lookup_name() will try to split the string at the colon,
> i.e., will try to modify r/o data. That will, in fact, fail on a kernel
> with enabled CONFIG_DEBUG_RODATA.
>
> Avoid modifying the passed string in module_kallsyms_lookup_name(),
> modify find_module_all() instead to pass it the module name length.
>
> Signed-off-by: Mathias Krause <minipli@googlemail.com>

Applied, thanks.

Cheers,
Rusty.
