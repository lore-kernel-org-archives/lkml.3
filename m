Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757562AbaCRS4H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 14:56:07 -0400
Received: from mga02.intel.com ([134.134.136.20]:24998 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757531AbaCRS4F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 14:56:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,679,1389772800"; 
   d="scan'208";a="475106907"
Message-ID: <532896C3.106@linux.intel.com>
Date: Tue, 18 Mar 2014 11:56:03 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: "Ted Ts'o" <tytso@mit.edu>, Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <michael@ellerman.id.au>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 4/4] random: Add arch_has_random[_seed]()
References: <1395099390-807-1-git-send-email-hpa@linux.intel.com>	 <1395099390-807-5-git-send-email-hpa@linux.intel.com> <1395114240.15098.205.camel@pasglop>
In-Reply-To: <1395114240.15098.205.camel@pasglop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/17/2014 08:44 PM, Benjamin Herrenschmidt wrote:
> On Mon, 2014-03-17 at 16:36 -0700, H. Peter Anvin wrote:
>> Add predicate functions for having arch_get_random[_seed]*().  The
>> only current use is to avoid the loop in arch_random_refill() when
>> arch_get_random_seed_long() is unavailable.
> 
> Paul, I think our HW rng on P7+ and later would qualify no ?
> 
> Cheers,
> Ben.

Just to be clear: since I don't know the parameters of the PowerPC hwrng
I just put in the stub functions, leaving it up to you to analyze if it
is suitable and analyze it.  Do let me know if I can be of any
assistance, of course.

	-hpa



