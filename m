Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755645Ab3FTIGo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 04:06:44 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:27975 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754957Ab3FTIGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 04:06:41 -0400
Date: Thu, 20 Jun 2013 11:06:14 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Alessandro Rubini <rubini@gnudd.com>
Cc: joe@perches.com, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [patch -next] FMC: NULL dereference on allocation failure
Message-ID: <20130620080614.GR5008@mwanda>
References: <1371658504.2038.25.camel@joe-AO722>
 <20130619160101.GA29108@mwanda>
 <20130619175758.GA23533@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130619175758.GA23533@mail.gnudd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 19, 2013 at 07:57:58PM +0200, Alessandro Rubini wrote:
> I'm not a fan of kcalloc. I think it removes readability.

Ok.  We'll go with my original patch then.

regards,
dan carpenter

