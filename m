Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753609Ab3I2LrG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 07:47:06 -0400
Received: from ud10.udmedia.de ([194.117.254.50]:42394 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223Ab3I2LrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 07:47:04 -0400
Date: Sun, 29 Sep 2013 13:47:00 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Andi Kleen <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [GIT PULL] perf fixes
Message-ID: <20130929114700.GB282@x4>
References: <20130928180327.GA5000@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130928180327.GA5000@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013.09.28 at 20:03 +0200, Ingo Molnar wrote:
> Andi Kleen (1):
>       perf symbols: Demangle cloned functions

The commit above e95ab53645:

 commit de95ab53645a2f0015e0f68ee723f18dce2b8b51
 Author: Andi Kleen <ak@linux.intel.com>
 Date:   Thu Sep 12 08:16:38 2013 -0700

     perf symbols: Demangle cloned functions

breaks "perf top" on my machine. I just see a gray screen with no text
at all. Sometimes the following error messages are printed:
 *** Error in `perf': invalid fastbin entry (free): 0x00000000029b18c0 ***
 *** Error in `perf': malloc(): memory corruption (fast): 0x0000000000ee0b10 ***

Reverting the commit "fixes" the issue.

-- 
Markus
