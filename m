Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760125Ab3CHA4a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 19:56:30 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39255 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760097Ab3CHA43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 19:56:29 -0500
Date: Thu, 7 Mar 2013 16:56:42 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Mike Frysinger <vapier@gentoo.org>, Ingo Molnar <mingo@kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <linux@arm.linux.org.uk>, Michal Simek <monstr@monstr.eu>,
        Ralf Baechle <ralf@linux-mips.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mundt <lethal@linux-sh.org>,
        "David S. Miller" <davem@davemloft.net>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Richard Weinberger <richard@nod.at>
Subject: Re: [PATCH v2] early_printk: consolidate random copies of identical
 code
Message-Id: <20130307165642.00153a01.akpm@linux-foundation.org>
In-Reply-To: <CAP=VYLpeqVOC2ZpCdnPDuLrRjwdpbHn3XQoSwAUaYFRdwQPfaQ@mail.gmail.com>
References: <1362683754-706-1-git-send-email-paul.gortmaker@windriver.com>
	<20130307112536.82288f41924a38a441cdf345@linux-foundation.org>
	<5138EF7F.1050003@windriver.com>
	<20130307133542.8bdb23612990fa25c5cc9112@linux-foundation.org>
	<CAP=VYLpeqVOC2ZpCdnPDuLrRjwdpbHn3XQoSwAUaYFRdwQPfaQ@mail.gmail.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Mar 2013 19:49:35 -0500 Paul Gortmaker <paul.gortmaker@windriver.com> wrote:

> > otoh, offering useless stuff to non-kernel-developers has downsides
> > with no balancing benefit, and we really should optimise things for
> > our users because there are so many more of them than there are of us.
> 
> Glad to hear that, and I agree totally.  I hope the above three lines
> will persuade people to merge practical/sane dependency lines that
> have the end users in mind, instead of focusing on ease of local testing.

It is possible to just ignore the Kconfig system and type "make
drivers/foo/bar.o".  Sometimes this actually works.

