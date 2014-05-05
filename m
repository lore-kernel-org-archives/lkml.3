Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932077AbaEEJ7x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 05:59:53 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:28459 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755764AbaEEJ7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 05:59:52 -0400
Date: Mon, 5 May 2014 12:59:35 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, Seunghun Lee <waydi1@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: android: fix missing a blank line after
 declarations
Message-ID: <20140505095935.GO26890@mwanda>
References: <1398790752-8067-1-git-send-email-waydi1@gmail.com>
 <20140429173221.GE26890@mwanda>
 <20140503234326.GA30117@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140503234326.GA30117@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 03, 2014 at 07:43:26PM -0400, Greg KH wrote:
> On Tue, Apr 29, 2014 at 08:32:21PM +0300, Dan Carpenter wrote:
> > On Wed, Apr 30, 2014 at 01:59:12AM +0900, Seunghun Lee wrote:
> > > This patch fixes "Missing a blank line after declarations" warnings.
> > > 
> > > Signed-off-by: Seunghun Lee <waydi1@gmail.com>
> > 
> > Quite a few of these are false checkpatch.pl false positives.  Just
> > ignore the false positives.
> 
> Really?  It looks good to me, what am I missing?
> 

Gar.  You're right.  In my head I remember seeing a bunch of false
positives but now that I'm looking at it again I'm not sure what I was
talking about.

regards,
dan carpenter

