Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757265AbaFTIOg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 04:14:36 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:26290 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753701AbaFTIOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 04:14:34 -0400
Date: Fri, 20 Jun 2014 11:14:23 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: josh@joshtriplett.org
Cc: Johannes Stadlinger <Johannes.Stadlinger@fau.de>,
        devel@driverdev.osuosl.org,
        Maximilian Eschenbacher <maximilian@eschenbacher.email>,
        linux-kernel@i4.cs.fau.de,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Himangi Saraogi <himangi774@gmail.com>,
        devel@linuxdriverproject.org
Subject: Re: [PATCH 3/8] wlan-ng/prism2mgmt:checkpatch: Insert blank line
Message-ID: <20140620081423.GQ5500@mwanda>
References: <1403205620-10219-1-git-send-email-Johannes.Stadlinger@fau.de>
 <1403205620-10219-3-git-send-email-Johannes.Stadlinger@fau.de>
 <20140619201140.GB16404@cloud>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140619201140.GB16404@cloud>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 19, 2014 at 01:11:40PM -0700, josh@joshtriplett.org wrote:
> On Thu, Jun 19, 2014 at 09:20:15PM +0200, Johannes Stadlinger wrote:
> > This patch inserts a blank line after a declaration to avoid checkpatch
> > warning.
> > 
> > Signed-off-by: Johannes Stadlinger <Johannes.Stadlinger@fau.de>
> > Signed-off-by: Maximilian Eschenbacher <maximilian@eschenbacher.email>
> > CC: linux-kernel@i4.cs.fau.de
> > CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > CC: Josh Triplett <josh@joshtriplett.org>
> > CC: Himangi Saraogi <himangi774@gmail.com>
> > CC: Vitaly Osipov <vitaly.osipov@gmail.com>
> > CC: devel@driverdev.osuosl.org
> > CC: linux-kernel@vger.kernel.org
> 
> This is one case where I think checkpatch is just wrong; this doesn't
> make the code any more (or less) readable.
> 
> Meh-by: Josh Triplett <josh@joshtriplett.org>

We've asked about making checkpatch ignore small blocks but apparently
that is a hard thing.  It's less work to apply these than to argue about
them and adding a space doesn't hurt so meh is correct.

regards,
dan carpenter

