Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760374AbaEMLHC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 07:07:02 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45036 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759512AbaEMLG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 07:06:59 -0400
Date: Tue, 13 May 2014 13:06:58 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Anton Kolesov <Anton.Kolesov@synopsys.com>,
        Francois Bedard <Francois.Bedard@synopsys.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 3.14 27/83] ARC: !PREEMPT: Ensure Return to kernel mode
 is IRQ safe
Message-ID: <20140513110658.GA28761@kroah.com>
References: <20140511191907.024339448@linuxfoundation.org>
 <20140511191910.756830473@linuxfoundation.org>
 <C2D7FE5348E1B147BCA15975FBA230751A6AC711@IN01WEMBXA.internal.synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C2D7FE5348E1B147BCA15975FBA230751A6AC711@IN01WEMBXA.internal.synopsys.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 12, 2014 at 04:54:56AM +0000, Vineet Gupta wrote:
> 
> On Monday 12 May 2014 12:51 AM, Greg Kroah-Hartman wrote:
> > 3.14-stable review patch.  If anyone has any objections, please let me know.
> >
> > ------------------
> >
> > From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
> >
> > commit 8aa9e85adac609588eeec356e5a85059b3b819ba upstream.
> 
> Hi Greg,
> 
> This one was also marked for stable 3.10 however because the 2 pre-req patches
> were not in yet, applying it would have failed and AFAIKR I did describe the state
> of things in that failure report. Anyhow can you please queue this one up for the
> next 3.10 stable.

Now applied, sorry for the delay.

greg k-h
