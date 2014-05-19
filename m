Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754626AbaESOf3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 10:35:29 -0400
Received: from ec2-54-201-57-178.us-west-2.compute.amazonaws.com ([54.201.57.178]:56597
	"EHLO ip-172-31-12-36.us-west-2.compute.internal"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750787AbaESOf1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 10:35:27 -0400
Date: Mon, 19 May 2014 14:30:33 +0000
From: dwalker@fifo99.com
To: Paul Bolle <pebolle@tiscali.nl>
Cc: David Brown <davidb@codeaurora.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arm: msm: remove board file for Nexus One (ie. mahimahi)
Message-ID: <20140519143033.GA17442@fifo99.com>
References: <1400101656.9826.4.camel@x220>
 <20140515174448.GA31159@fifo99.com>
 <1400177413.11786.11.camel@x220>
 <20140515215726.GA1171@fifo99.com>
 <1400500408.2007.29.camel@x220>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400500408.2007.29.camel@x220>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2014 at 01:53:28PM +0200, Paul Bolle wrote:
> Daniel,
> 
> On Thu, 2014-05-15 at 21:57 +0000, dwalker@fifo99.com wrote:
> > On Thu, May 15, 2014 at 08:10:13PM +0200, Paul Bolle wrote:
> > > This is not something I get to decide. Nevertheless, given that this
> > > file shouldn't have been merged to begin with, I'd appreciate it if some
> > > deadline could be agreed upon.
> > 
> > I think I merged it actually, but there's no rules about what gets merged. How when what order, etc.
> > It's all free form.
> 
> There do not seem to be formal rules. But there surely are some
> requirements for code to be added. One of the requirements is, I think,
> that it should build. This file cannot be built: it is not wired into a
> Makefile and it also includes, what appears to be, its own header file,
> but that header is not part of the tree.

The requirements are created by the maintainers.. In this case I would have expected
support for this phone much sooner, and there are in fact patches on the list to support
it which just haven't been merged yet. 

> Even the most dubious of code in drivers/staging is expected to "compile
> properly"!

But mach-msm isn't staging, different rules apply there.

Daniel
