Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753507AbaEDBAE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2014 21:00:04 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58634 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752987AbaEDBAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2014 21:00:03 -0400
Date: Sat, 3 May 2014 19:43:26 -0400
From: Greg KH <gregkh@linuxfoundation.org>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Seunghun Lee <waydi1@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: android: fix missing a blank line after
 declarations
Message-ID: <20140503234326.GA30117@kroah.com>
References: <1398790752-8067-1-git-send-email-waydi1@gmail.com>
 <20140429173221.GE26890@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140429173221.GE26890@mwanda>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2014 at 08:32:21PM +0300, Dan Carpenter wrote:
> On Wed, Apr 30, 2014 at 01:59:12AM +0900, Seunghun Lee wrote:
> > This patch fixes "Missing a blank line after declarations" warnings.
> > 
> > Signed-off-by: Seunghun Lee <waydi1@gmail.com>
> 
> Quite a few of these are false checkpatch.pl false positives.  Just
> ignore the false positives.

Really?  It looks good to me, what am I missing?

greg k-h
