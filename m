Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752110AbbASNdb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 08:33:31 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:35672 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751659AbbASNd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 08:33:29 -0500
X-Sasl-enc: dBkXlciJtXcJOzWKLk7lLgSj1cbe2gu97PeO3IlSFiMC 1421674408
Date: Mon, 19 Jan 2015 21:26:17 +0800
From: Greg KH <greg@kroah.com>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Cc: "stable@vger.kernel.org" <stable@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: stable 3.14 backport request for ARC
Message-ID: <20150119132617.GA32038@kroah.com>
References: <C2D7FE5348E1B147BCA15975FBA2307565BC9324@IN01WEMBXA.internal.synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C2D7FE5348E1B147BCA15975FBA2307565BC9324@IN01WEMBXA.internal.synopsys.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 23, 2014 at 08:08:51AM +0000, Vineet Gupta wrote:
> Hi,
> 
> Can you please backport the following mainline commits to 3.14 stable.
> 
> 2014-02-07 ec7ac6afd07b ARC: switch to generic ENTRY/END assembler annotations

Now queued up.

> 2014-04-18 64ee9f32c33c ARC: Delete stale barrier.h

I don't see how this is an issue for 3.14, it says it fixes a 3.15 build
issue only, so I didn't apply it.  Why did you ask for it?

thanks,

greg k-h
