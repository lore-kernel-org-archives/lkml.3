Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753929AbaLMTqw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2014 14:46:52 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:44785 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752813AbaLMTqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2014 14:46:51 -0500
Date: Sat, 13 Dec 2014 11:46:47 -0800
From: Jeremiah Mahler <jmmahler@gmail.com>
To: Loic Pefferkorn <loic@loicp.eu>
Cc: gregkh@linuxfoundation.org, alan@linux.intel.com, jun.j.tian@intel.com,
        octavian.purdila@intel.com, nnk@google.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: goldfish: Fix minor coding style
Message-ID: <20141213194647.GA30065@hudson.localdomain>
Mail-Followup-To: Jeremiah Mahler <jmmahler@gmail.com>,
	Loic Pefferkorn <loic@loicp.eu>, gregkh@linuxfoundation.org,
	alan@linux.intel.com, jun.j.tian@intel.com,
	octavian.purdila@intel.com, nnk@google.com,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
References: <e2a3b3ccf85790c865683832698908458931be6a.1418487651.git.loic@loicp.eu>
 <20141213175518.GA28616@hudson.localdomain>
 <20141213182238.GA6979@iron>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20141213182238.GA6979@iron>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Loïc,

On Sat, Dec 13, 2014 at 07:22:38PM +0100, Loic Pefferkorn wrote:
> > Whose convention is this?  I can't find any mention in
> > Documention/CodingStyle. checkpatch.pl doesn't complain about them.
> > And there are almost three thousand examples in staging which don't
> > use this convention.
> > 
> >   linux-next$ grep -r "== NULL" drivers/staging/* | wc -l
> >   2844
> 
> Hi Jeremiah,
> 
> Thanks for your feedback.
> 
> I have used checkpatch.pl with the --strict flag:
> 
> $ ./scripts/checkpatch.pl --strict -f drivers/staging/goldfish/goldfish_nand.c
> CHECK: Comparison to NULL could be written "!cps"
> #51: FILE: drivers/staging/goldfish/goldfish_nand.c:51:
> +   if (cps == NULL)
> 
> CHECK: Comparison to NULL could be written "!name"
> #333: FILE: drivers/staging/goldfish/goldfish_nand.c:333:
> +   if (name == NULL)
> 
> CHECK: Comparison to NULL could be written "!r"
> #382: FILE: drivers/staging/goldfish/goldfish_nand.c:382:
> +   if (r == NULL)
> 
> CHECK: Comparison to NULL could be written "!base"
> #386: FILE: drivers/staging/goldfish/goldfish_nand.c:386:
> +   if (base == NULL)
> 
> CHECK: Comparison to NULL could be written "!nand"
> #402: FILE: drivers/staging/goldfish/goldfish_nand.c:402:
> +   if (nand == NULL)
> 
> total: 0 errors, 0 warnings, 5 checks, 442 lines checked
> 
> drivers/staging/goldfish/goldfish_nand.c has style problems, please review.
> 
> I have also found another commit having the same purpose: 7f376cd6dc1c9bfd14514c70765e6900a961c4b8
> 
> -- 
> Cheers,
> Loïc

It looks like you're right.  I must say I am surprised.  I had no idea
checkpatch.pl could be even more pedantic than it already is :-)

-- 
- Jeremiah Mahler
