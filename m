Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756310Ab3GWKSt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 06:18:49 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:50137 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753242Ab3GWKSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 06:18:48 -0400
Date: Tue, 23 Jul 2013 13:18:38 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Lilis Iskandar <veeableful@gmail.com>
Cc: devel@driverdev.osuosl.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: bcm: Qos: Fix some coding style issues
Message-ID: <20130723101838.GN5585@mwanda>
References: <1374571229.15906.3.camel@desktop>
 <20130723095416.GM5585@mwanda>
 <1374574241.17286.8.camel@desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374574241.17286.8.camel@desktop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 23, 2013 at 06:10:41PM +0800, Lilis Iskandar wrote:
> Hi Dan,
> 
> I have already accepted my fate when I submitted the patch. Though it's
> really great that I receive a response so fast :)
> 
> Regarding the braces, I thought it would be more readable that way
> because of the long code wrapping inside the "if" parameter.

The way to do that is to use spaces to align the stuff in the if
statement.

	if (long_ blah blah blah blah blah blah ==
	    this part lines up with the 'l' in "long_")
		frob();

Read CodingStyle.  One other thing is that in staging we prefer if
multi-line indents have braces around them even if it's not needed.

Ugly:
	for (i = 0; i < 100; i++)
		if (x) {
			frob();
			frob();
			frob();
		}

Nice to look at:
	for (i = 0; i < 100; i++) {
		if (x) {
			frob();
			frob();
			frob();
		}
	}

> I'll fix it and send the patches again in pieces. Should I send a
> new mail or reply to this thread?

This thread, but it doesn't matter.

regards,
dan carpenter


