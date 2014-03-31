Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751247AbaCaToc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 15:44:32 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:22554 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974AbaCaToa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 15:44:30 -0400
Date: Mon, 31 Mar 2014 22:44:16 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Joe Perches <joe@perches.com>
Cc: devel@driverdev.osuosl.org, Rocco Folino <lordzen87@gmail.com>,
        aaro.koskinen@iki.fi, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, Andy Whitcroft <apw@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC] quiet checkpatch style recommendation about no spaces
 around bitfield :
Message-ID: <20140331194416.GR6991@mwanda>
References: <1396269280-32665-1-git-send-email-lordzen87@gmail.com>
 <20140331150638.GQ6991@mwanda>
 <1396279898.21529.39.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396279898.21529.39.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 31, 2014 at 08:31:38AM -0700, Joe Perches wrote:
> On Mon, 2014-03-31 at 18:06 +0300, Dan Carpenter wrote:
> > On Mon, Mar 31, 2014 at 02:34:40PM +0200, Rocco Folino wrote:
> > > Fixed bit fields code style issues
> []
> > > diff --git a/drivers/staging/octeon-usb/octeon-hcd.h b/drivers/staging/octeon-usb/octeon-hcd.h
> []
> > > @@ -143,13 +143,13 @@ union cvmx_usbcx_gahbcfg {
> > >  	 *	* 1'b1: Unmask the interrupt assertion to the application.
> > >  	 */
> > >  	struct cvmx_usbcx_gahbcfg_s {
> > > -		uint32_t reserved_9_31	: 23;
> > > -		uint32_t ptxfemplvl	: 1;
> > > -		uint32_t nptxfemplvl	: 1;
> > > -		uint32_t reserved_6_6	: 1;
> > > -		uint32_t dmaen		: 1;
> > > -		uint32_t hbstlen	: 4;
> > > -		uint32_t glblintrmsk	: 1;
> > > +		uint32_t reserved_9_31:23;
> > > +		uint32_t ptxfemplvl:1;
> > > +		uint32_t nptxfemplvl:1;
> > > +		uint32_t reserved_6_6:1;
> > > +		uint32_t dmaen:1;
> > > +		uint32_t hbstlen:4;
> > > +		uint32_t glblintrmsk:1;
> > >  	} s;
> > The warning here is:
> > ERROR: spaces prohibited around that ':' (ctx:WxW)
> > I have done a kernel wide search for these warnings
> 
> Really?  How?

Just a:

find -name \*.[ch] -exec ./scripts/checkpatch.pl -f \{\} \;

Or whatever...  It takes 2 1/2 hours.

regards,
dan carpenter

