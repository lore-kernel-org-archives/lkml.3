Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935024Ab3FSR56 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 13:57:58 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:39885 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933869Ab3FSR5z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 13:57:55 -0400
Date: Wed, 19 Jun 2013 19:57:47 +0200
From: Alessandro Rubini <rubini@gnudd.com>
To: dan.carpenter@oracle.com
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [patch] FMC: NULL dereference on allocation failure
Message-ID: <20130619175747.GA23508@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
In-Reply-To: <20130619155731.GA4957@mwanda>
References: <20130619155731.GA4957@mwanda>
  <20130619144904.GA10484@elgon.mountain>
  <20130619152528.GA16430@mail.gnudd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Apparently these are going through Greg K-H.  I'll resend, with Greg
> CC'd so he can pick it up from the mailing list.
> 
> Could you add an entry to the MAINTAINERS file so that Greg will be
> CC'd automatically using get_maintainer.pl?

Ok.  Added to my todo list.

> Is there a dedicated list for FMC development?  That would go in the
> MAINTAINERS file as well.

No, there is no list. Or "not yet".  The project was born externally
(on ohwr.org), mainly within the "white rabbit" research group.  If it
makes sense, we can have a public list, I'm all for it.

thanks
/alessandro
