Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753281AbaDCS2c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 14:28:32 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:37734 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752907AbaDCS20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 14:28:26 -0400
Date: Thu, 3 Apr 2014 19:28:21 +0100
From: Andy Whitcroft <apw@canonical.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Joe Perches <joe@perches.com>, Dan Carpenter <dan.carpenter@oracle.com>,
        Rocco Folino <lordzen87@gmail.com>, aaro.koskinen@iki.fi,
        devel@driverdev.osuosl.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] quiet checkpatch style recommendation about no spaces
 around bitfield :
Message-ID: <20140403182821.GB3495@bark>
References: <1396269280-32665-1-git-send-email-lordzen87@gmail.com>
 <20140331150638.GQ6991@mwanda>
 <1396279898.21529.39.camel@joe-AO722>
 <20140331135628.d8eb8bea432d509835710202@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140331135628.d8eb8bea432d509835710202@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 31, 2014 at 01:56:28PM -0700, Andrew Morton wrote:
> On Mon, 31 Mar 2014 08:31:38 -0700 Joe Perches <joe@perches.com> wrote:
> 
> > > > @@ -143,13 +143,13 @@ union cvmx_usbcx_gahbcfg {
> > > >  	 *	* 1'b1: Unmask the interrupt assertion to the application.
> > > >  	 */
> > > >  	struct cvmx_usbcx_gahbcfg_s {
> > > > -		uint32_t reserved_9_31	: 23;
> > > > -		uint32_t ptxfemplvl	: 1;
> > > > -		uint32_t nptxfemplvl	: 1;
> > > > -		uint32_t reserved_6_6	: 1;
> > > > -		uint32_t dmaen		: 1;
> > > > -		uint32_t hbstlen	: 4;
> > > > -		uint32_t glblintrmsk	: 1;
> > > > +		uint32_t reserved_9_31:23;
> > > > +		uint32_t ptxfemplvl:1;
> > > > +		uint32_t nptxfemplvl:1;
> > > > +		uint32_t reserved_6_6:1;
> > > > +		uint32_t dmaen:1;
> > > > +		uint32_t hbstlen:4;
> > > > +		uint32_t glblintrmsk:1;
> > > >  	} s;
> > > The warning here is:
> > > ERROR: spaces prohibited around that ':' (ctx:WxW)
> > > I have done a kernel wide search for these warnings
> > 
> > Really?  How?
> > 
> > >  and I think we
> > > should disable this warning.  It has too many false positives like this.
> > 
> > It does seem a bit noisy to me too.
> > 
> > Andy?  Andrew?
> 
> I suspect we don't use bitfields enough for a particular style to have
> emerged.  Personally I think the above patch made the code harder to
> read, so...

Yeah it seems the predominant style would trigger the warning.  So turn
it off.

-apw
