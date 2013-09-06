Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754594Ab3IFWYx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 18:24:53 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:53691 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750726Ab3IFWYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 18:24:52 -0400
Date: Fri, 6 Sep 2013 23:18:57 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: behanw@converseincode.com
Cc: Mark Charlebois <charlebm@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Dave Jones <davej@redhat.com>,
        "moderated list:ARM PORT" <linux-arm-kernel@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arm: LLVMLinux: Calculate pt_regs address from fp
Message-ID: <20130906221857.GQ6617@n2100.arm.linux.org.uk>
References: <1378503762-7236-1-git-send-email-behanw@converseincode.com> <1378503762-7236-2-git-send-email-behanw@converseincode.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378503762-7236-2-git-send-email-behanw@converseincode.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 06, 2013 at 05:42:41PM -0400, behanw@converseincode.com wrote:
> From: Behan Webster <behanw@converseincode.com>
> 
> Use the frame pointer to calculate the end of the stack for current_pt_regs()
> The existing code uses the stack pointer to do this calculation.
> Using the frame pointer yeilds the same value in a more portable way.
> This change supports being able to compile the kernel with gcc and clang.

What happens when frame pointers are disabled on gcc?
