Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761469Ab3BNRDR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 12:03:17 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:20374 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755903Ab3BNRDQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 12:03:16 -0500
MIME-Version: 1.0
Message-ID: <7ad0cf40-61bd-4a1e-a4f0-e27fbc3543fd@default>
Date: Thu, 14 Feb 2013 09:02:47 -0800 (PST)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Konrad Wilk <konrad.wilk@oracle.com>, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, sjenning@linux.vnet.ibm.com,
        rcj@linux.vnet.ibm.com
Subject: RE: [PATCH] Various cleanups/fixes to zcache (v3).
References: <1360811106-2679-1-git-send-email-konrad.wilk@oracle.com>
 <56c69426-968a-4d0b-a254-dd03456e30d3@default>
 <20130214165920.GA26615@kroah.com>
In-Reply-To: <20130214165920.GA26615@kroah.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.7  (607090) [OL
 12.0.6665.5003 (x86)]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Greg KH [mailto:gregkh@linuxfoundation.org]
> Subject: Re: [PATCH] Various cleanups/fixes to zcache (v3).
> 
> On Thu, Feb 14, 2013 at 08:56:01AM -0800, Dan Magenheimer wrote:
> > > From: Konrad Rzeszutek Wilk [mailto:konrad.wilk@oracle.com]
> > > Subject: [PATCH] Various cleanups/fixes to zcache (v3).
> > >
> > > From Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> # This line is ignored.
> > > From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > > Subject: [PATCH] Various cleanups/fixes to zcache (v3).
> > > In-Reply-To:
> > >
> > > Hey Greg,
> > >
> > > These patches do various cleanups of the zcache driver. The majority of the
> > > work is just to move all the different counters out to a debug file. The next
> > > step would be to figure out which ones are actually pertient and which can
> > > go under the knife. Oh, and also fix some of the compiler warnings.
> > >
> > > This is based on top of ommit 76426daf50d5df38893cc189e9ccd026093debc8
> > > ("staging/zcache: Fix/improve zcache writeback code, tie to a config option")
> > > so should apply cleanly to your tree.
> > >
> > > Please apply.
> >
> > Useful cleanups.
> >
> > Hopefully not too late for 3.9-rc0.
> 
> You all did see my "the staging tree is closed except for bugfixes for
> 3.9" message last week, right?

Oops, sorry, no I missed that.
 
> Sorry, this will have to wait for 3.10.

No problem, no bugs fixed here, though I expect we'll see
the same complaints posted again about the compiler warnings.

Dan
