Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757497Ab3ETQix (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 12:38:53 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45325 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755157Ab3ETQiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 12:38:51 -0400
Date: Mon, 20 May 2013 09:38:50 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Jon Mason <jon.mason@intel.com>
Cc: Jonghwan Choi <jhbird.choi@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jonghwan Choi <jhbird.choi@samsung.com>
Subject: Re: [PATCH 3.9-stable] ntb: off by one sanity checks
Message-ID: <20130520163850.GA28172@kroah.com>
References: <1368844538-3841-1-git-send-email-jhbird.choi@samsung.com>
 <20130518144709.GA29066@jonmason-lab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130518144709.GA29066@jonmason-lab>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 18, 2013 at 07:47:09AM -0700, Jon Mason wrote:
> On Sat, May 18, 2013 at 11:35:38AM +0900, Jonghwan Choi wrote:
> > From: Dan Carpenter <dan.carpenter@oracle.com>
> > 
> > This patch looks like it should be in the 3.9-stable tree, should we apply
> > it?
> 
> Yes, please do.  I'll respond to each of the patch series, but please
> apply them all.  Also, one patch was omitted from these, titled 
> NTB: variable dereferenced before check
> 
> Please include that patch in 3.9 stable as well.

Can you just send me the git commit ids of the patches you wish to see
applied to the stable tree, and the order in which they need to go in?

Also, in the future, please tag the patches you want in the stable
releases with the proper "Cc: Stable <stable@vger.kernel.org>" line in
the signed-off-by: area of the patch, so I can pick it up automagically.

thanks,

greg k-h
