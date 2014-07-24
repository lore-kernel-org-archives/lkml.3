Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933671AbaGXWPe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 18:15:34 -0400
Received: from mga02.intel.com ([134.134.136.20]:36496 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759603AbaGXWP1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 18:15:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,727,1400050800"; 
   d="scan'208";a="578576544"
Message-ID: <53D1857B.4050307@linux.intel.com>
Date: Thu, 24 Jul 2014 15:15:23 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>, Andy Lutomirski <luto@amacapital.net>
CC: Borislav Petkov <bp@alien8.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        X86 ML <x86@kernel.org>
Subject: Re: STI architectural question (and lretq -- I'm not even kidding)
References: <CALCETrVx=cLZjgALizYKWATSjOvhmwPHQvOJRkMgdb=iNRNf8w@mail.gmail.com> <8738drrcxp.fsf@tassilo.jf.intel.com> <CALCETrWKQgnZfNmcQcROc1rOuoks7=P6VjGvwoE3aP4jTTgC0A@mail.gmail.com> <20140723231032.GZ18735@two.firstfloor.org>
In-Reply-To: <20140723231032.GZ18735@two.firstfloor.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/23/2014 04:10 PM, Andi Kleen wrote:
>> I think that, other than broadcast MCEs, #MC that hits in kernel mode
>> is non-recoverable, or at least can't safely be recovered.  (There's a
>> separate APIC interrupt for recoverable errors, I think, but that's a
>> much saner interface.)
> 
> There are multiple valid cases where #MC can return.
> 

Indeed, not just broadcast #MC.

	-hpa


