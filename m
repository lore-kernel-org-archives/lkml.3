Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755436Ab3HMJB3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 05:01:29 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:36870 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753156Ab3HMJB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 05:01:27 -0400
Date: Tue, 13 Aug 2013 12:00:39 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Anton Vorontsov'" <anton@enomsg.org>,
        "'David Woodhouse'" <dwmw2@infradead.org>,
        linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>
Subject: Re: [PATCH 33/35] power: use dev_get_platdata()
Message-ID: <20130813090039.GA5604@mwanda>
References: <005c01ce8cfd$82078af0$8616a0d0$@samsung.com>
 <20130809220451.GG12638@lizard.sbx05730.santaca.wayport.net>
 <003401ce96f2$0f53b840$2dfb28c0$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <003401ce96f2$0f53b840$2dfb28c0$@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 12, 2013 at 09:22:42AM +0900, Jingoo Han wrote:
> On Saturday, August 10, 2013 7:05 AM, Anton Vorontsov wrote:
> > On Tue, Jul 30, 2013 at 05:19:27PM +0900, Jingoo Han wrote:
> > > Use the wrapper function for retrieving the platform data instead of
> > > accessing dev->platform_data directly.
> > 
> > Um.. what is the benefit or rationale of this patch?
> 
> CC'ed Joe Perches, Dan Carpenter
> 
> Hi Anton Vorontsov,
> 
> Usually, using the wrapper function makes the code simpler.
> Also, it make the code more readable.

Since people are asking my opinion, then yes using
dev_get_platdata() as intended is better than open coding.  It's a
coding standard thing.

regards,
dan carpenter

