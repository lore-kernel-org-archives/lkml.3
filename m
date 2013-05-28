Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759066Ab3E1WPR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 18:15:17 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:57190 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757902Ab3E1WPP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 18:15:15 -0400
Message-ID: <1369779315.22004.81.camel@joe-AO722>
Subject: Re: [PATCH]: Kernel Oops Priority Level in <linux/printk.h>
From: Joe Perches <joe@perches.com>
To: Christopher Sacchi <christophersacchi@gmail.com>
Cc: linux-kernel@vger.kernel.org
Date: Tue, 28 May 2013 15:15:15 -0700
In-Reply-To: <CABQQNFFAxX3jV4h83g1bhNkwEu2=4R2kqk4E5QAPirB=N3dTAw@mail.gmail.com>
References: <CABQQNFFAxX3jV4h83g1bhNkwEu2=4R2kqk4E5QAPirB=N3dTAw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-05-28 at 18:08 -0400, Christopher Sacchi wrote:
> Here is a patch for linux-3.10-rc2 that adds a KERN_OOPS priority
> level as a handler for if a kernel oops occurs, (this priority can be
> used for a message to the kernel log,) and it is applied to
> linux/printk.h in the include directory. It has been checked and has 2
[]
> +++ include/linux/printk.h  2013-05-28 17:39:21.530055578 -0400
> @@ -395,4 +395,8 @@ static inline void print_hex_dump_bytes(
[]
> +/* Define an oops priority level. */
> +#define pr_oops(fmt, ...) \
> +          printk(KERN_OOPS pr_fmt(fmt), ##__VA_ARGS__)
> +
> #endif

Why?  Why not KERN_DEFAULT?
Where is KERN_OOPS #defined?


