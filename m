Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934563Ab3JPTJk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 15:09:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36518 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933954Ab3JPTJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 15:09:39 -0400
Date: Wed, 16 Oct 2013 12:09:38 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Eli Billauer <eli.billauer@gmail.com>
Cc: Dhanunjaya <dhanunjaya.matrix@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Staging: xillybus: fix for quoted string split
 across lines
Message-ID: <20131016190938.GA19071@kroah.com>
References: <1381946272-18651-1-git-send-email-dhanunjaya.matrix@gmail.com>
 <20131016180627.GA17116@kroah.com>
 <525EDFAF.8030306@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <525EDFAF.8030306@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 16, 2013 at 09:49:19PM +0300, Eli Billauer wrote:
> Hello Greg,
> 
> On 16/10/13 21:06, Greg KH wrote:
> >>  	rc = of_address_to_resource(dev->of_node, 0,&endpoint->res);
> >>>    	if (rc) {
> >>>  -		pr_warn("xillybus: Failed to obtain device tree "
> >>>  -			"resource\n");
> >>>  +		pr_warn("xillybus: Failed to obtain device tree resource\n");
> >This should be using dev_warn() instead.
> >
> 
> So I understand that I should replace *all* occurrences of pr_warn()
> and pr_err() with their dev_* counterparts?

Yes.
