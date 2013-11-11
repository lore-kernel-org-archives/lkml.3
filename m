Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052Ab3KKXer (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 18:34:47 -0500
Received: from mga09.intel.com ([134.134.136.24]:37607 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753394Ab3KKXek (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 18:34:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="407133205"
Message-ID: <5281698F.9080808@linux.intel.com>
Date: Mon, 11 Nov 2013 15:34:39 -0800
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>, "H. Peter Anvin" <hpa@zytor.com>
CC: linux-arch <linux-arch@vger.kernel.org>, mingo@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        james.t.kukunas@intel.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Miller <davem@davemloft.net>
Subject: Re: [tip:x86/asm] x86, bitops:  Change bitops to be native operand
 size
References: <tip-z61ofiwe90xeyb461o72h8ya@git.kernel.org>	 <1384117768.3081.10.camel@joe-AO722>	 <5ac67859-a0b2-47f5-bdc2-c2a52b8d6885@email.android.com>	 <1384123457.3081.33.camel@joe-AO722> <52803BA2.2080908@zytor.com> <1384136570.4771.5.camel@joe-AO722>
In-Reply-To: <1384136570.4771.5.camel@joe-AO722>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10/2013 06:22 PM, Joe Perches wrote:
> 
> Perhaps the current x86 bitops asm code is being conflated
> with the ideal implementation?
> 

Yes, by you.

x86 has instructions that operate on signed bitindicies.  It doesn't
have instructions that operate on unsigned bitindicies.  Unless someone
is willing to do the work to prove that shift and mask is actually
faster than using the hardware instructions (which I doubt, but it is
always a possibility), that's what we have.

	-hpa

