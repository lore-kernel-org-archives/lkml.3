Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754468AbaESOEM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 10:04:12 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:41572 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751630AbaESOEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 10:04:10 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+q5QSFqYARgmXBaaM2aED96YL0725M79I=
X-DKIM: OpenDKIM Filter v2.0.1 titan 4E0F6579C40
Date: Mon, 19 May 2014 10:04:05 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Anton Saraev <antonysaraev@gmail.com>, gregkh@linuxfoundation.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org, jake@lwn.net
Subject: Re: [PATCH v2 05/06] staging: crypto: skein: rename macros
Message-ID: <20140519140405.GF27822@titan.lakedaemon.net>
References: <cover.1399675444.git.antonysaraev@gmail.com>
 <2eac124c6a3815c72e91679c8cde729af712bb74.1399675445.git.antonysaraev@gmail.com>
 <20140519090839.GR15585@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140519090839.GR15585@mwanda>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2014 at 12:08:39PM +0300, Dan Carpenter wrote:
> On Mon, May 19, 2014 at 12:09:58PM +0400, Anton Saraev wrote:
> > +/* ignore all asserts, for performance */
> > +#define skein_assert_ret(x, ret_code)
> > +#define skein_assert(x)
> 
> Not related to this patch, but defining away asserts like this is a bad
> idea.  What if they have side affects like:
> 
> 	skein_assert(foo++ == bar);

Agreed.  This driver is definitely a work in progress.  If you look at
the history, you'll see that I started with a bit-for-bit copy of a
publicly available reference implementation.  After we get the coding
style in shape, there are plenty of other improvements to make.

Thanks for the review.

thx,

Jason.
