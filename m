Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754262AbaIBPYW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 11:24:22 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:46143 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751815AbaIBPYV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 11:24:21 -0400
Date: Tue, 2 Sep 2014 18:23:27 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc: Benjamin Romer <benjamin.romer@unisys.com>,
        David Kershner <david.kershner@unisys.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, sparmaintainer@unisys.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: unisys: uislib: uisqueue.c: fixed sparse
 warning of context imbalance
Message-ID: <20140902152327.GG6549@mwanda>
References: <1409656187-14215-1-git-send-email-sudipm.mukherjee@gmail.com>
 <20140902140532.GD6600@mwanda>
 <20140902151427.GA11966@sudip-PC>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140902151427.GA11966@sudip-PC>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 02, 2014 at 08:44:27PM +0530, Sudip Mukherjee wrote:
> On Tue, Sep 02, 2014 at 05:05:32PM +0300, Dan Carpenter wrote:
> > On Tue, Sep 02, 2014 at 04:39:47PM +0530, Sudip Mukherjee wrote:
> > > fixed sparse warning : context imbalance in 'do_locked_client_insert'
> > > 			 different lock contexts for basic block
> > > 
> > > spin_unlock_irqrestore is called at a later stage before returning 
> > > from the function if locked is 1.
> > > 
> > > Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
> > 
> > This doesn't match the email address you are using.
> > 
> 
> for all my patch the Signed-off email address is different from the From email address.
> I am not sure if I should do that, but since no one pointed it out so I guessed it is ok.

Sign-off-by are like signing a legal document that you didn't steal
copyright code.  We like to check that they match up with the email
sending the patch.

regards,
dan carpenter

