Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932694AbaHVQsh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 12:48:37 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:45173 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932208AbaHVQsg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 12:48:36 -0400
Date: Fri, 22 Aug 2014 10:48:25 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: =?iso-8859-1?Q?S=F6ren?= Brinkmann <soren.brinkmann@xilinx.com>
Cc: Andreas =?iso-8859-1?Q?F=E4rber?= <afaerber@suse.de>,
        Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 3/3] ARM: zynq: DT: Add Ethernet phys
Message-ID: <20140822164825.GA1733@obsidianresearch.com>
References: <1408550219-19825-1-git-send-email-soren.brinkmann@xilinx.com>
 <1408550219-19825-3-git-send-email-soren.brinkmann@xilinx.com>
 <5a7b6f57-b6c0-4fb3-af0d-d403277c0207@BN1AFFO11FD045.protection.gbl>
 <53F5D8D9.7040604@suse.de>
 <f166a186-301c-4288-97cf-71f8173c07e7@BN1AFFO11FD010.protection.gbl>
 <20140822162048.GB8477@obsidianresearch.com>
 <d31d72f2-acac-4aa3-b992-fc244ac6db4e@BY2FFO11FD005.protection.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d31d72f2-acac-4aa3-b992-fc244ac6db4e@BY2FFO11FD005.protection.gbl>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 22, 2014 at 09:31:20AM -0700, Sören Brinkmann wrote:

> > >  - the marvell compatible strings are used in our vendor tree. They
> > >    aren't used anywhere but in our vendor tree. I though keeping them is
> > >    nice since it identifies the PHY fully. And in case that level of
> > >    detail is needed at some point it is already there.
> > 
> > DT is complex enough already, don't include useless compatible strings
> > in mainline - people will see and tend to blindly copy. Ideally your
> > vendor tree would use the standard property :|
> 
> There are different opinions on this. I also heard to just add such
> strings, so in case this level of differentiation becomes necessary at
> some later point, it is already existing.

In some cases, yes, and they should be docuemented in the binding, of
course.

But there is already a standard compatible string format to uniquely
identify a phy, so in this case another string is not justified, and
just creates confusion about what is correct.

Jason
