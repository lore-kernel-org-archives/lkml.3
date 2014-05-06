Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751586AbaEFQaB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 12:30:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41857 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750877AbaEFQ37 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 12:29:59 -0400
Date: Tue, 6 May 2014 12:29:46 -0400
From: Dave Jones <davej@redhat.com>
To: David Miller <davem@davemloft.net>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT] Sparc
Message-ID: <20140506162946.GA28261@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	David Miller <davem@davemloft.net>, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, sparclinux@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20140506.113031.1577209312429629073.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140506.113031.1577209312429629073.davem@davemloft.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 06, 2014 at 11:30:31AM -0400, David Miller wrote:
 > 
 > I've been auditing the THP support on sparc64 and found several bugs,
 > hopefully most of which are fixed completely here.
 
Hi Dave,

It seems like forever you go you sent me patches to trinity to make it
work on sparc. I'm curious if you've tried running it again more
recently ?   Given the work I've done it to do more creative things with
VM related syscalls, I wouldn't be surprised if it also found some sparc
specific bugs in thp.

It should now also scale up to run a lot more child processes than the older
version, with the -c option, which could be interesting on some of the
bigger sparc machines.

(It's entirely possible I've broken the compile on non-x86 in
 current git, but it shouldn't be much work to fix up).

git://github.com/kernelslacker/trinity is where it lives now.

	Dave

