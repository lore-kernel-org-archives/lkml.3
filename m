Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752873AbaLEMYJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 07:24:09 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:24295 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857AbaLEMYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 07:24:07 -0500
Date: Fri, 5 Dec 2014 15:23:15 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Paul Mackerras <paulus@samba.org>, linux-ppp@vger.kernel.org,
        netdev@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH v2 6/6] net-PPP: Delete another unnecessary assignment in
 mppe_alloc()
Message-ID: <20141205122315.GC4912@mwanda>
References: <530DD06F.4090703@users.sourceforge.net>
 <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>
 <5317A59D.4@users.sourceforge.net>
 <547B4886.4080406@users.sourceforge.net>
 <547B496E.604@users.sourceforge.net>
 <547C5CBC.6060607@cogentembedded.com>
 <547C82A6.2030808@users.sourceforge.net>
 <547CA157.1080401@cogentembedded.com>
 <5480DA32.8000201@users.sourceforge.net>
 <5480DE25.2020802@users.sourceforge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5480DE25.2020802@users.sourceforge.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 04, 2014 at 11:20:21PM +0100, SF Markus Elfring wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Thu, 4 Dec 2014 22:42:30 +0100
> 
> The data structure element "sha1" was assigned a null pointer by the
> mppe_alloc() after a function call "crypto_alloc_hash" failed.

This patch is also buggy.

regards,
dan carpenter

