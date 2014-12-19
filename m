Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752512AbaLSLqL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 06:46:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56454 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751364AbaLSLqJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 06:46:09 -0500
Message-ID: <54940C4D.6010405@redhat.com>
Date: Fri, 19 Dec 2014 12:30:21 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Fam Zheng <famz@redhat.com>
CC: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stefan Hajnoczi <stefanha@redhat.com>
Subject: Re: patch tracking tools (was Re: Maintainer abuse)
References: <alpine.DEB.2.11.1412130016090.16494@nanos> <20141212234336.GA28451@pd.tnic> <20141213135231.5684cf9d@lxorguk.ukuu.org.uk> <5492A8F0.9030107@redhat.com> <20141218132505.GB21344@fam-t430.nay.redhat.com>
In-Reply-To: <20141218132505.GB21344@fam-t430.nay.redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 18/12/2014 14:25, Fam Zheng wrote:
> > One thing that makes automation a bit easier for QEMU is that it does
> > not have a merge window; while we do have a central committer that takes
> > pull requests, the phases are a bit more traditional (2 month
> > development, 2 weeks preparation for freeze, 1 month feature freeze).
> > For Linux it would be more important for the tool to know which patches
> > are for which tree, possibly based on the destination mailing lists.
>
> Things can be complicated, for example patch series dependencies.  It's a
> question to think about whether we need it to be complete or want to keep it
> simple.

I think we want to keep it simple.  Patch series dependencies complicate
the job for the maintainer too.

Andrea Arcangeli reminded me later of the obvious: for Linux such a tool
could simply use the linux-next tree as a base.

Paolo
