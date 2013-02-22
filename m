Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758403Ab3BVRHq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 12:07:46 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:50778 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757687Ab3BVRHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 12:07:44 -0500
X-Sasl-enc: 0PSlnLL6UQml3YVo2BkHGj4pKMM8r1cm4UQMtRd3HAOd 1361552863
Date: Fri, 22 Feb 2013 09:07:42 -0800
From: Greg KH <greg@kroah.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jan Beulich <JBeulich@suse.com>
Cc: stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Put git commit 51ac8893a7a51b196501164e645583bf78138699 on the
 stable tree please
Message-ID: <20130222170742.GA5126@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5127AED302000078000C0779@nat28.tlf.novell.com>
 <20130222165704.GA21811@phenom.dumpdata.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 22, 2013 at 11:57:04AM -0500, Konrad Rzeszutek Wilk wrote:
> On Fri, Feb 22, 2013 at 08:19:30AM -0800, Greg KH wrote:
> > On Fri, Feb 22, 2013 at 10:46:45AM -0500, Konrad Rzeszutek Wilk wrote:
> > > Hey Greg,
> > > 
> > > Please put git commit 51ac8893a7a51b196501164e645583bf78138699
> > > commit 51ac8893a7a51b196501164e645583bf78138699
> > > Author: Jan Beulich <jbeulich@suse.com>
> > > Date:   Wed Feb 6 10:30:38 2013 -0500
> > > 
> > >     xen-pciback: rate limit error messages from xen_pcibk_enable_msi{,x}()
> > > 
> > > on the stable tree please. It is an security errata fix and should
> > > have had the CC: stable@vger.kernel.org but did not.
> > 
> > Thanks, what stable kernel releases should it be queued up for?
> 
> 3.4 and later please.

On Fri, Feb 22, 2013 at 04:45:55PM +0000, Jan Beulich wrote:
> Anyone from 3.1 onwards that is still being maintained.

Hm, who should I believe here...  :)

It doesn't matter for me, but for the 3.2 tree, it does.

thanks,

greg k-h
