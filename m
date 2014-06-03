Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932147AbaFCAMJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 20:12:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43365 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752020AbaFCAMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 20:12:07 -0400
Date: Mon, 2 Jun 2014 17:15:44 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Sune =?iso-8859-1?Q?M=F8lgaard?= <sune@molgaard.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] Summarizing deprecations
Message-ID: <20140603001544.GB17821@kroah.com>
References: <53893895.3040202@molgaard.org>
 <20140531022151.GA32348@kroah.com>
 <538944E2.2070706@molgaard.org>
 <20140531033711.GA1697@kroah.com>
 <538D04D4.1060906@molgaard.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <538D04D4.1060906@molgaard.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 03, 2014 at 01:12:20AM +0200, Sune Mølgaard wrote:
> Hi again, and thank you still for interacting,
> 
> Greg KH wrote:
> > What specific drivers are they?  Why are the drivers out of the tree?
> > I'll gladly add them to the drivers/staging/ directory as long as the
> > license of them allows me to do so.  That way api changes will happen
> > automatically for them.
> 
> For at least one of the manufacturers, I have already pointed them in
> your direction with regards to the previously mentioned project. They
> lamented that they would love to take you up on your offer, but that
> their legal department was less than enthusiastic, based on fear of
> repercussions from their chip suppliers.
> 
> This particular company could be a candidate for positive nudging from
> stronger entities than myself, as just one guy.

Feel free to follow up with me about this company and contacts
privately, if you feel I can help out there.

> It stands to reason, though, that there may not only be legal obstacles
> to supporting OSS drivers, but also that corporate resources allocated
> to keeping their "monstrosity" current may be severely lacking.

Take away the legal issues (their side, not ours), and then merge the
driver into the kernel and then all of those maintenance issues go
away for the most part, allowing a single developer to just baby-sit the
driver to ensure nothing goes wrong on newer kernel releases.

That's the Linux kernel development model, it's worked really well for
the past 20+ years, creating something that works on more hardware than
any other operating system ever has, so we must be doing something right
here with the model :)

greg k-h
