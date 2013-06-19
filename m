Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757099Ab3FSP5s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 11:57:48 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:35122 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757074Ab3FSP5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 11:57:46 -0400
Date: Wed, 19 Jun 2013 18:57:32 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Alessandro Rubini <rubini@gnudd.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] FMC: NULL dereference on allocation failure
Message-ID: <20130619155731.GA4957@mwanda>
References: <20130619144904.GA10484@elgon.mountain>
 <20130619152528.GA16430@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130619152528.GA16430@mail.gnudd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 19, 2013 at 05:25:28PM +0200, Alessandro Rubini wrote:
> > If we don't allocate "arr" then the cleanup path will dereference it and
> > oops.
> 
> You are right, thanks (acked).
> 
> How is the procedure here? I don't have my own git tree on
> kernel.org for pull requests. Can this go through the janitors?
> 
> (if it makes sense, I can try the procedure to have a tree, but last
> time I checked it was strictly denied to anyone).


Apparently these are going through Greg K-H.  I'll resend, with Greg
CC'd so he can pick it up from the mailing list.

Could you add an entry to the MAINTAINERS file so that Greg will be
CC'd automatically using get_maintainer.pl?  Is there a dedicated
list for FMC development?  That would go in the MAINTAINERS file as
well.

regards,
dan carpenter

