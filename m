Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754656Ab3BYQrH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 11:47:07 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:37004 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751412Ab3BYQrC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 11:47:02 -0500
Date: Mon, 25 Feb 2013 11:46:54 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Greg KH <greg@kroah.com>
Cc: Jan Beulich <JBeulich@suse.com>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Put git commit 51ac8893a7a51b196501164e645583bf78138699 on the
  stable tree please
Message-ID: <20130225164654.GA10672@phenom.dumpdata.com>
References: <5127AED302000078000C0779@nat28.tlf.novell.com>
 <20130222165704.GA21811@phenom.dumpdata.com>
 <20130222170742.GA5126@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130222170742.GA5126@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 22, 2013 at 09:07:42AM -0800, Greg KH wrote:
> On Fri, Feb 22, 2013 at 11:57:04AM -0500, Konrad Rzeszutek Wilk wrote:
> > On Fri, Feb 22, 2013 at 08:19:30AM -0800, Greg KH wrote:
> > > On Fri, Feb 22, 2013 at 10:46:45AM -0500, Konrad Rzeszutek Wilk wrote:
> > > > Hey Greg,
> > > > 
> > > > Please put git commit 51ac8893a7a51b196501164e645583bf78138699
> > > > commit 51ac8893a7a51b196501164e645583bf78138699
> > > > Author: Jan Beulich <jbeulich@suse.com>
> > > > Date:   Wed Feb 6 10:30:38 2013 -0500
> > > > 
> > > >     xen-pciback: rate limit error messages from xen_pcibk_enable_msi{,x}()
> > > > 
> > > > on the stable tree please. It is an security errata fix and should
> > > > have had the CC: stable@vger.kernel.org but did not.
> > > 
> > > Thanks, what stable kernel releases should it be queued up for?
> > 
> > 3.4 and later please.
> 
> On Fri, Feb 22, 2013 at 04:45:55PM +0000, Jan Beulich wrote:
> > Anyone from 3.1 onwards that is still being maintained.
> 
> Hm, who should I believe here...  :)

Just in case my previous email crossed paths or got deleted.
> 
> It doesn't matter for me, but for the 3.2 tree, it does.

3.1 and later please.
