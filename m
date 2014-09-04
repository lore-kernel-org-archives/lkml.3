Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755395AbaIDUZ4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 16:25:56 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:31322 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752920AbaIDUZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 16:25:54 -0400
Date: Thu, 4 Sep 2014 23:25:38 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc: Sudip Mukherjee <sudip@vectorindia.org>,
        Benjamin Romer <benjamin.romer@unisys.com>,
        David Kershner <david.kershner@unisys.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, sparmaintainer@unisys.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] staging: unisys: uislib: uisqueue.c: rewrite of
 do_locked_client_insert
Message-ID: <20140904202538.GS6549@mwanda>
References: <1409736561-23883-1-git-send-email-sudip@vectorindia.org>
 <20140903095950.GF6600@mwanda>
 <20140904164116.GA1084@sudip-PC>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140904164116.GA1084@sudip-PC>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 04, 2014 at 10:11:16PM +0530, Sudip Mukherjee wrote:
> On Wed, Sep 03, 2014 at 12:59:50PM +0300, Dan Carpenter wrote:
> > On Wed, Sep 03, 2014 at 02:59:21PM +0530, Sudip Mukherjee wrote:
> > > 1) removed unused variables
> > > 2) fixed sparse warning of context imbalance in 'do_locked_client_insert'
> > >                          different lock contexts for basic block
> > > 3) removed the call to visor_signalqueue_empty() , this function is
> > >    checking whether a signal queue is empty, but the return value
> > >    of the function is not beeing used, so it is safe to remove.
> > > 
> > > Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
> > 
> > Looks good.  Thanks!
> > 
> > Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>
> > 
> > regards,
> > dan carpenter
> 
> do i need to resend the patch after adding Reviewed-by to it ?
> 

No.  Greg will reply (perhaps an automated message) when he gets to the
patch.  Otherwise your job is done.

regards,
dan carpenter

