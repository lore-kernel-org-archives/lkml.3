Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756164Ab3AWSAe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 13:00:34 -0500
Received: from mail-pb0-f47.google.com ([209.85.160.47]:58876 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755405Ab3AWSAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 13:00:33 -0500
Date: Wed, 23 Jan 2013 10:00:27 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Kernel Security <security@kernel.org>,
        Michael Davidson <md@google.com>,
        Suleiman Souhlal <suleiman@google.com>, Julien Tinnes <jln@google.com>,
        Aaron Durbin <adurbin@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Roland McGrath <roland@hack.frob.com>, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>
Subject: Re: [PATCH 0/4] (Was: ptrace: prevent PTRACE_SETREGS from corrupting
 stack)
Message-ID: <20130123180027.GA6435@kroah.com>
References: <20130116181830.GA6469@redhat.com>
 <CA+55aFzkWqSEzw9oa5JodrM2NWE0H_AF7xyzRhd+DQ=PB=ZT2A@mail.gmail.com>
 <20130118153700.GA27915@redhat.com>
 <CA+55aFxEow_-PoX0xFa07yOi6az=6uVx8zeOsfToErmzh7dB8A@mail.gmail.com>
 <20130118172854.GA29753@redhat.com>
 <20130118175224.GA520@redhat.com>
 <CA+55aFyEsU-pkX557A-m+xoGkA_v+fXEyA8z8HbJ5J8K1jObeg@mail.gmail.com>
 <20130118185559.GA3773@redhat.com>
 <CA+55aFy=newnMbx53HipyWbRs2mUUPSqXXCpSfDLW78gkro37g@mail.gmail.com>
 <20130120192448.GA6771@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130120192448.GA6771@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 20, 2013 at 08:24:48PM +0100, Oleg Nesterov wrote:
> Greg, this doesn't look like -stable material. But please let me know
> if you think 2/4 should be backported. With a couple of simple hacks
> in PTRACE_DETACH/LISTEN paths we can do this without 1/4 and without
> changes outside of ptrace.c. But again, probably we shouldn't do this.

I think it is -stable material, and I've now applied the three patches
that went into Linus's tree into the 3.4-stable and 3.7-stable trees.
There was only one minor patch problem with 3.4 (comment block not being
needed), if there is more work than that that you think is needed to get
these working in those kernel releases, please let me know.

thanks,

greg k-h
