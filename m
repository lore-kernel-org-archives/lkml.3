Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756029AbaIDFHo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 01:07:44 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:38627 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092AbaIDFHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 01:07:43 -0400
Date: Thu, 4 Sep 2014 07:07:39 +0200
From: Ingo Molnar <mingo@kernel.org>
To: "H. Peter Anvin" <h.peter.anvin@intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: RFC: Tainting the kernel on raw I/O access
Message-ID: <20140904050739.GA27112@gmail.com>
References: <5407863B.9030608@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5407863B.9030608@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <h.peter.anvin@intel.com> wrote:

> In a meeting earlier today, we discussed MSR access and that it could be
> used to do bad things.  The same applies to other forms of raw I/O
> (/dev/mem, /dev/port, ioperm, iopl, etc.)
> 
> This is basically the same problem with which the secure boot people
> have been struggling.
> 
> Peter Z. suggested we should taint the kernel on raw I/O access, and I
> tend to concur.

Lets start with the 'only for developers and the crazy' 
interfaces, like /dev/msr access, and extend it step by step?

Thanks,

	Ingo
