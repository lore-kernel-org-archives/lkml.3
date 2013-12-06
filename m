Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756198Ab3LFHMn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 02:12:43 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:30130 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755573Ab3LFHM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 02:12:26 -0500
Date: Fri, 6 Dec 2013 10:11:12 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Joe Perches <joe@perches.com>
Cc: Will Tange <bh34rt@gmail.com>, gregkh@linuxfoundation.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: silicom: fix 'return is not a function,
 parentheses are not required' in bpctl_mod.c
Message-ID: <20131206071112.GF5443@mwanda>
References: <1386278633-29641-1-git-send-email-bh34rt@gmail.com>
 <20131205225051.GC28413@mwanda>
 <1386284955.10003.20.camel@joe-AO722>
 <20131205232140.GE5443@mwanda>
 <1386286162.10003.24.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386286162.10003.24.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 05, 2013 at 03:29:22PM -0800, Joe Perches wrote:
> On Fri, 2013-12-06 at 02:21 +0300, Dan Carpenter wrote:
> > On Thu, Dec 05, 2013 at 03:09:15PM -0800, Joe Perches wrote:
> > > On Fri, 2013-12-06 at 01:50 +0300, Dan Carpenter wrote:
> > > > On Thu, Dec 05, 2013 at 10:23:53PM +0100, Will Tange wrote:
> 
> Ah.
> 
> Then maybe use a single ?: or a ! instead
> 
> 	return ret ? 0 : 1;
> or
> 	return !ret;
> 

You still have to handle the negative.

	if (ret < 0)
		return ret;

	return !ret;

regards,
dan carpenter
