Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030356Ab3BNW6U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 17:58:20 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:26056 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030250Ab3BNW6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 17:58:18 -0500
Date: Thu, 14 Feb 2013 17:57:40 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Dan Magenheimer <dan.magenheimer@oracle.com>, devel@linuxdriverproject.org,
        rcj@linux.vnet.ibm.com, sjenning@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Various cleanups/fixes to zcache (v3).
Message-ID: <20130214225740.GA8104@phenom.dumpdata.com>
References: <1360811106-2679-1-git-send-email-konrad.wilk@oracle.com>
 <56c69426-968a-4d0b-a254-dd03456e30d3@default>
 <20130214165920.GA26615@kroah.com>
 <7ad0cf40-61bd-4a1e-a4f0-e27fbc3543fd@default>
 <20130214172926.GA17343@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130214172926.GA17343@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14, 2013 at 09:29:26AM -0800, Greg KH wrote:
> On Thu, Feb 14, 2013 at 09:02:47AM -0800, Dan Magenheimer wrote:
> > > From: Greg KH [mailto:gregkh@linuxfoundation.org]
> > > Subject: Re: [PATCH] Various cleanups/fixes to zcache (v3).
> > > 
> > > On Thu, Feb 14, 2013 at 08:56:01AM -0800, Dan Magenheimer wrote:
> > > > > From: Konrad Rzeszutek Wilk [mailto:konrad.wilk@oracle.com]
> > > > > Subject: [PATCH] Various cleanups/fixes to zcache (v3).
> > > > >
> > > > > From Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> # This line is ignored.
> > > > > From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > > > > Subject: [PATCH] Various cleanups/fixes to zcache (v3).
> > > > > In-Reply-To:
> > > > >
> > > > > Hey Greg,
> > > > >
> > > > > These patches do various cleanups of the zcache driver. The majority of the
> > > > > work is just to move all the different counters out to a debug file. The next
> > > > > step would be to figure out which ones are actually pertient and which can
> > > > > go under the knife. Oh, and also fix some of the compiler warnings.
> > > > >
> > > > > This is based on top of ommit 76426daf50d5df38893cc189e9ccd026093debc8
> > > > > ("staging/zcache: Fix/improve zcache writeback code, tie to a config option")
> > > > > so should apply cleanly to your tree.
> > > > >
> > > > > Please apply.
> > > >
> > > > Useful cleanups.
> > > >
> > > > Hopefully not too late for 3.9-rc0.
> > > 
> > > You all did see my "the staging tree is closed except for bugfixes for
> > > 3.9" message last week, right?
> > 
> > Oops, sorry, no I missed that.
> >  
> > > Sorry, this will have to wait for 3.10.
> > 
> > No problem, no bugs fixed here, though I expect we'll see
> > the same complaints posted again about the compiler warnings.
> 
> Then why not just redo that one patch, and send it to me, and then
> rebase all of the other patches on top of it?  That way I can accept the
> "fix the complier warnings" patch now, and the rest can wait.

Aye aye captain. Going to send them tomorrow (zbud/zcache).
