Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751982AbaKYGYJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 01:24:09 -0500
Received: from mail-wg0-f50.google.com ([74.125.82.50]:55733 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840AbaKYGYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 01:24:07 -0500
Date: Tue, 25 Nov 2014 07:24:02 +0100
From: Ingo Molnar <mingo@kernel.org>
To: nick <xerofoify@gmail.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        dave.hansen@linux.intel.com, bp@suse.de, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Obsolete Fix Me in main.c due to not included header file
Message-ID: <20141125062402.GA17059@gmail.com>
References: <5473E8BD.2050105@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5473E8BD.2050105@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* nick <xerofoify@gmail.com> wrote:

> Greeting Thomas and other maintainers, I am wondering why we 
> still need a fix me for including types.h,as this seems correct 
> and good according to my reading of the other header files this 
> file needs to function. Nick

So your first few mails were OK, but now you are coming close to 
a dozen emails in my mbox alone, and the thing is, there's over 
4,000 FIXME's in the kernel source:

  comet:~/tip> git grep -i FIXME | wc -l
  4415

These FIXME's are there to warn active developers about issues to 
work on - and they generally get removed when that code gets 
fixed or changes later on, typically without generating any 
separate commit. (Sometimes they don't get removed for a longer 
time - there's not much harm as eventually they will be removed.)

In other words: please stop this stream of mostly pointless 
emails! Instead of generating 4,000+ additional emails, please 
try to find some real bug to work on?

Thanks,

	Ingo
