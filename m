Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754487AbaADBYs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 20:24:48 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:16404 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754258AbaADBYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 20:24:47 -0500
Date: Fri, 3 Jan 2014 17:23:37 -0800
From: Mukesh Rathor <mukesh.rathor@oracle.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: David Vrabel <david.vrabel@citrix.com>, linux-kernel@vger.kernel.org,
        xen-devel@lists.xenproject.org, boris.ostrovsky@oracle.com,
        stefano.stabellini@eu.citrix.com
Subject: Re: [PATCH v12 10/18] xen/pvh: Update E820 to work with PVH (v2)
Message-ID: <20140103172337.1e077e56@mantra.us.oracle.com>
In-Reply-To: <20140102184133.GE3021@pegasus.dumpdata.com>
References: <1388550945-25499-1-git-send-email-konrad.wilk@oracle.com>
	<1388550945-25499-11-git-send-email-konrad.wilk@oracle.com>
	<52C59068.1040603@citrix.com>
	<20140102184133.GE3021@pegasus.dumpdata.com>
Organization: Oracle Corporation
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.18.9; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Jan 2014 13:41:34 -0500
Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:

> On Thu, Jan 02, 2014 at 04:14:32PM +0000, David Vrabel wrote:
> > On 01/01/14 04:35, Konrad Rzeszutek Wilk wrote:
> > > From: Mukesh Rathor <mukesh.rathor@oracle.com>
> > > 
> > > In xen_add_extra_mem() we can skip updating P2M as it's managed
> > > by Xen. PVH maps the entire IO space, but only RAM pages need
> > > to be repopulated.
> > 
> > So this looks minimal but I can't work out what PVH actually needs
> > to do here.  This code really doesn't need to be made any more
> > confusing.
> 
> I gather you prefer Mukesh's original version?

I think Konrad thats easier to follow as one can quickly spot
the PVH difference... but your call.

thanks
mukesh

