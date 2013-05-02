Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756426Ab3EBKWS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 06:22:18 -0400
Received: from www.linutronix.de ([62.245.132.108]:39049 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751545Ab3EBKWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 06:22:17 -0400
Date: Thu, 2 May 2013 12:22:05 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] timer changes for v3.10
In-Reply-To: <CA+55aFwaQMjKDV5aA=_2mNiF1msGZO2hX3gypCZTByzDZxX6DQ@mail.gmail.com>
Message-ID: <alpine.LFD.2.02.1305021221180.3972@ionos>
References: <20130430074322.GA20110@gmail.com> <CA+55aFwaQMjKDV5aA=_2mNiF1msGZO2hX3gypCZTByzDZxX6DQ@mail.gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Apr 2013, Linus Torvalds wrote:
> Both sets of patches were done by Thomas, and I *really* want you guys
> to take a look at my conflict resolution. I effectively moved the new
> "don't go into deep idle if boradcast timer is pending" check from x86
> and arm into the generic idle loop. So my merge resolution is
> semantically quite different  from either branch, but the alternative
> seemed to be to remove the new check entirely.
> 
> I pushed my merge out, please take a look.

Perfect!

	tglx
