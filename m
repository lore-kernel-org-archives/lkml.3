Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758295Ab3BVRDr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 12:03:47 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:24634 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758142Ab3BVRDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 12:03:46 -0500
Date: Fri, 22 Feb 2013 12:03:38 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jan Beulich <JBeulich@suse.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org
Subject: Re: Put git commit 51ac8893a7a51b196501164e645583bf78138699 on the
 stable tree please
Message-ID: <20130222170338.GA28453@phenom.dumpdata.com>
References: <20130222154644.GB8809@phenom.dumpdata.com>
 <20130222161930.GA27694@kroah.com>
 <5127AED302000078000C0779@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5127AED302000078000C0779@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 22, 2013 at 04:45:55PM +0000, Jan Beulich wrote:
> >>> On 22.02.13 at 17:19, Greg KH <gregkh@linuxfoundation.org> wrote:
> > On Fri, Feb 22, 2013 at 10:46:45AM -0500, Konrad Rzeszutek Wilk wrote:
> >> Hey Greg,
> >> 
> >> Please put git commit 51ac8893a7a51b196501164e645583bf78138699
> >> commit 51ac8893a7a51b196501164e645583bf78138699
> >> Author: Jan Beulich <jbeulich@suse.com>
> >> Date:   Wed Feb 6 10:30:38 2013 -0500
> >> 
> >>     xen-pciback: rate limit error messages from xen_pcibk_enable_msi{,x}()
> >> 
> >> on the stable tree please. It is an security errata fix and should
> >> have had the CC: stable@vger.kernel.org but did not.
> > 
> > Thanks, what stable kernel releases should it be queued up for?
> 
> Anyone from 3.1 onwards that is still being maintained.

What Jan said please.
> 
> Jan
> 
