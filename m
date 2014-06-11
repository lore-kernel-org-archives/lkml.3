Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755493AbaFKHtX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 03:49:23 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:27084 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754833AbaFKHtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 03:49:22 -0400
Date: Wed, 11 Jun 2014 10:47:04 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Andy Whitcroft <apw@shadowen.org>, LKML <linux-kernel@vger.kernel.org>,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [RFC PATCH] checkpatch: Attempt to find unnecessary 'out of
 memory' messages
Message-ID: <20140611074704.GS5015@mwanda>
References: <1402419340.30479.18.camel@joe-AO725>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402419340.30479.18.camel@joe-AO725>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Dan Carpenter <dan.carpenter@oracle.com>

This check introduces 1849 new checkpatch.pl warnings.  I looked through
the first 70 warnings and there were no false positives.

Besides the bloat issue, I don't like these warnings because they make
the error handling harder to read.  They are sort of a mindless thing
that people feel they have to do for no particular reason.  Since
people aren't thinking when they write the error message then you get
NULL dereferences and so on.

regards,
dan carpenter

