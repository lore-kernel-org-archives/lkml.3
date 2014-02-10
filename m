Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932088AbaBJUYA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 15:24:00 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:24885 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753437AbaBJUX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 15:23:59 -0500
Date: Mon, 10 Feb 2014 23:24:11 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
Subject: Re: WARNING: Unnecessary parentheses - maybe == should be = ?
Message-ID: <20140210202411.GD26776@mwanda>
References: <20140210092710.GA10899@elgon.mountain>
 <1392052786.2507.20.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392052786.2507.20.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 10, 2014 at 09:19:46AM -0800, Joe Perches wrote:
> On Mon, 2014-02-10 at 12:27 +0300, Dan Carpenter wrote:
> > These messages are terrifying...
> 
> Hey Dan.
> 
> Do bumps in the night keep you up too? :)
> 
> > We do not want to encourage a million
> > first patch submitters to start introducing = vs == bugs.
> 
> Definitely true and I didn't think of that.
> 

So long as we can re-phrase it then I don't have a problem with the
warning.

regards,
dan carpenter

