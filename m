Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753181AbaC3Knp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 06:43:45 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:23118 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570AbaC3Knn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 06:43:43 -0400
Date: Sun, 30 Mar 2014 13:43:35 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Joe Perches <joe@perches.com>
Cc: =?iso-8859-1?B?Suly9G1l?= Pinot <ngc891@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] staging/ozwpan: coding style ether_addr_copy
Message-ID: <20140330104335.GG19296@mwanda>
References: <20140312100132.GA18954@star>
 <20140312144533.GA3410@kroah.com>
 <20140313012144.GD30138@star>
 <20140313022821.GA9084@kroah.com>
 <20140313153911.GA17881@star>
 <20140328111801.GD6991@mwanda>
 <1396012107.31134.21.camel@joe-AO722>
 <20140329232952.GF19296@mwanda>
 <1396142606.21529.9.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396142606.21529.9.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 29, 2014 at 06:23:26PM -0700, Joe Perches wrote:
> On Sun, 2014-03-30 at 02:29 +0300, Dan Carpenter wrote:
> > These days in the kernel we treat checkpatch.pl and GCC
> > warnings the same so it sucks when they are something conditional.
> 
> Treating checkpatch messages like gcc compilation warnings
> and failures has got to change.
> 
> There is _no way_ checkpatch can have no false positives.
> 

We could argue back and forth, but for now lets just revert the
ether_addr_copy() check because people ignore the alignement requirement
and it just encourages people to introduce bugs.

regards,
dan carpenter

