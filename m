Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753424AbaLEN5p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 08:57:45 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:37887 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933AbaLEN5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 08:57:43 -0500
Date: Fri, 5 Dec 2014 16:57:23 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Paul Mackerras <paulus@samba.org>, linux-ppp@vger.kernel.org,
        netdev@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH v2 5/6] net-PPP: Delete an unnecessary assignment in
 mppe_alloc()
Message-ID: <20141205135723.GE4912@mwanda>
References: <5317A59D.4@users.sourceforge.net>
 <547B4886.4080406@users.sourceforge.net>
 <547B496E.604@users.sourceforge.net>
 <547C5CBC.6060607@cogentembedded.com>
 <547C82A6.2030808@users.sourceforge.net>
 <547CA157.1080401@cogentembedded.com>
 <5480DA32.8000201@users.sourceforge.net>
 <5480DDC1.6040101@users.sourceforge.net>
 <20141205122214.GB4912@mwanda>
 <5481A8AE.9050506@users.sourceforge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5481A8AE.9050506@users.sourceforge.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 05, 2014 at 01:44:30PM +0100, SF Markus Elfring wrote:
> >> The data structure element "arc4" was assigned a null pointer by the
> >> mppe_alloc() function if a previous function call "crypto_alloc_blkcipher"
> >> failed.
> > 
> > crypto_alloc_blkcipher() returns error pointers and not NULL.
> 
> That is true.
> 

Oh.  In that case, I misunderstood what you wrote.  Looking at it now,
this patch is actually ok.

regards,
dan carpenter

