Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752143AbbAUHal (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 02:30:41 -0500
Received: from ozlabs.org ([103.22.144.67]:35347 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751827AbbAUHaf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 02:30:35 -0500
Message-ID: <1421825433.23864.2.camel@ellerman.id.au>
Subject: Re: [PATCH 1/2] printk: Add dummy routine for when CONFIG_PRINTK=n
From: Michael Ellerman <mpe@ellerman.id.au>
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        Petr Mladek <pmladek@suse.cz>, Joe Perches <joe@perches.com>,
        John Stultz <john.stultz@linaro.org>,
        Dan Streetman <ddstreet@ieee.org>,
        Simon =?ISO-8859-1?Q?K=E5gstr=F6m?= 
	<simon.kagstrom@netinsight.net>,
        Borislav Petkov <bp@suse.de>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        open list <linux-kernel@vger.kernel.org>
Date: Wed, 21 Jan 2015 18:30:33 +1100
In-Reply-To: <1421797911-23650-1-git-send-email-bobby.prani@gmail.com>
References: <1421797911-23650-1-git-send-email-bobby.prani@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2015-01-20 at 18:51 -0500, Pranith Kumar wrote:
> There are missing dummy routines for log_buf_addr_get() and log_buf_len_get()
> for when CONFIG_PRINTK is not set causing build failures.
> 
> This patch adds these dummy routines at the appropriate location.
> 
> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
> CC: Michael Ellerman <mpe@ellerman.id.au>

Are folks on CC happy if we take this via the powerpc tree?

Apologies for not getting it right the first time.

cheers


