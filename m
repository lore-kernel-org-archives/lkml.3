Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517Ab3H2OTI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 10:19:08 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:40897 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753995Ab3H2OTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 10:19:04 -0400
Date: Thu, 29 Aug 2013 10:19:03 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "H. Peter Anvin" <hpa@zytor.com>
cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Russell King <linux@arm.linux.org.uk>, Ingo Molnar <mingo@redhat.com>,
        David Howells <dhowells@redhat.com>, Ming Lei <ming.lei@canonical.com>,
        USB list <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Memory synchronization vs. interrupt handlers
In-Reply-To: <521E5D58.5070708@zytor.com>
Message-ID: <Pine.LNX.4.44L0.1308291017070.1170-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Aug 2013, H. Peter Anvin wrote:

> On 08/28/2013 12:16 PM, Alan Stern wrote:
> > Russell, Peter, and Ingo:
> > 
> > Can you folks enlighten us regarding this issue for some common 
> > architectures?
> > 
> 
> On x86, IRET is a serializing instruction; it guarantees hard
> serialization of absolutely everything.

That answers half of the question.  What about the other half?  Does 
the CPU automatically serialize everything when it takes an interrupt?

> I would expect architectures that have weak memory ordering to put
> appropriate barriers in the IRQ entry/exit code.

Then would it be acceptable to mention this in the memory-barriers.txt 
file?

Alan Stern

