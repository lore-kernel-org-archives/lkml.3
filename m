Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753399Ab3JALGz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 07:06:55 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:43369 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752394Ab3JALGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 07:06:53 -0400
Date: Tue, 1 Oct 2013 13:06:50 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul Mackerras <paulus@au1.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>, James Hogan <james.hogan@imgtec.com>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        "#3.9.." <stable@vger.kernel.org>
Subject: [GIT PULL v2] irq: updates for 3.13
Message-ID: <20131001110649.GB24825@localhost.localdomain>
References: <1380553367-9631-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380553367-9631-1-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 30, 2013 at 05:02:47PM +0200, Frederic Weisbecker wrote:
> Ingo, Thomas,
> 
> Please pull the irq/core-v5 branch that can be found at:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
> 	irq/core-v5
> 
> HEAD: f6f626fa877c96974fadc595ddd72543d8c6106b

I have rebased this branch on top of the fixed changelog from the urgent commit.
Please pull the new branch irq/core-v6 instead.

HEAD: 62d26c8200a8382e1c67419ca3aff78d37898cc5

Thanks.
