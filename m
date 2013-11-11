Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754262Ab3KKQe0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 11:34:26 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:10257 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753914Ab3KKQeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 11:34:18 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 108.39.110.144
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19KVkTtA9MSbcieD9ZM2tAGePtboW0vhtA=
Date: Mon, 11 Nov 2013 11:34:16 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        "linux-kernel@vger.kernel.org list" <linux-kernel@vger.kernel.org>
Subject: Re: common location for devicetree files
Message-ID: <20131111163416.GO10335@titan.lakedaemon.net>
References: <1438803E-C904-428B-B042-891978BC15DF@codeaurora.org>
 <20131108165255.GA32668@titan.lakedaemon.net>
 <5957C301-9698-45B0-BFED-749DE79D0A74@codeaurora.org>
 <20131108181351.GF10335@titan.lakedaemon.net>
 <2274FB81-099B-4206-8332-70E9824FFF2F@codeaurora.org>
 <20131108183240.GH10335@titan.lakedaemon.net>
 <528104AD.9030102@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <528104AD.9030102@wwwdotorg.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 11, 2013 at 09:24:13AM -0700, Stephen Warren wrote:
> On 11/08/2013 11:32 AM, Jason Cooper wrote:
> > On Fri, Nov 08, 2013 at 12:17:30PM -0600, Kumar Gala wrote:
> > ...
> >> I get the point, just not sure how else to sort the 800+ .dts{i} files
> >> that we have in the kernel tree right now.
> > 
> > Well, to start with, all #include'd files could go into a
> > arch/dts/include directory.  That would clean things up a bit.
> > 
> > We could also consider separating the dts files by ISA.  All armv7 in
> > one directory, armv8, armv5te, powerpc, mips, etc.
> 
> It's quite likely people will want to share some significant *.dtsi
> across multiple architectures.

Yes, I should've been more clear:

arch/
\-dts/
  |-armv5te/
  |-armv7/
  |-armv8/
  |-include/
  |-mips/
  |-powerpc/

etc.

so arch-independent includes could go in arch/dts/include/...

thx,

Jason.
