Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758118Ab3CDPDN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 10:03:13 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:42280 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757041Ab3CDPDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 10:03:11 -0500
Date: Mon, 4 Mar 2013 10:02:46 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jan Beulich <JBeulich@suse.com>
Cc: Paul Bolle <pebolle@tiscali.nl>, Ian Campbell <ian.campbell@citrix.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [ 34/77] xen/blkback: Dont trust the handle from the frontend.
Message-ID: <20130304150246.GA15794@phenom.dumpdata.com>
References: <20130301194351.913471337@linuxfoundation.org>
 <20130301194355.578429064@linuxfoundation.org>
 <1362172344.20156.15.camel@x61.thuisdomein>
 <1362253682.3768.136.camel@deadeye.wl.decadent.org.uk>
 <1362263724.1334.18.camel@x61.thuisdomein>
 <1362265843.3768.162.camel@deadeye.wl.decadent.org.uk>
 <1362306002.1334.29.camel@x61.thuisdomein>
 <5134617F02000078000C2AD8@nat28.tlf.novell.com>
 <1362388302.16460.5.camel@x61.thuisdomein>
 <5134741702000078000C2B3E@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5134741702000078000C2B3E@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 04, 2013 at 09:14:47AM +0000, Jan Beulich wrote:
> >>> On 04.03.13 at 10:11, Paul Bolle <pebolle@tiscali.nl> wrote:
> > On Mon, 2013-03-04 at 07:55 +0000, Jan Beulich wrote:
> >> >>> On 03.03.13 at 11:20, Paul Bolle <pebolle@tiscali.nl> wrote:
> >> For one, a fix for the (indeed valid) compiler warning has been in
> >> Konrad's tree for several days
> >> 
> > (http://git.kernel.org/cgit/linux/kernel/git/konrad/xen.git/commit/drivers/bl 
> > ock/xen-blkback/blkback.c?id=a72d9002f80bffd7e4c7d60e5a9caa0cddffe894).
> > 
> > Thanks. (For the record: that commit is titled "xen/xen-blkback:
> > preq.dev is used without initialized".)
> > 
> >> And second, there's nothing really being fixed with the patch in
> >> question here. The title is kind of misleading, as the handle
> >> coming from the frontend is - without said patch - in the worst
> >> case being used for the very message that triggered the
> >> compiler warning. Nothing else is affected, the code just gave
> >> the impression that the handle was used.

Which it actually is not, unless somebody compiles the kernel
with #define DEBUG 1
at the top of the file.

> >> 
> >> IOW I don't see why this got proposed for stable at all.
> > 
> > So, you suggest to just drop this patch for v3.8.3, don't you?
> 
> I do, yes. But I'd suggest to get Konrad to agree.

Yes. Lets drop it.
