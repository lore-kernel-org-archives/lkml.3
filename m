Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756814Ab3CNL2X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 07:28:23 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:18544 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754890Ab3CNL2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 07:28:22 -0400
Date: Thu, 14 Mar 2013 14:28:09 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: ccg: remove two outdated dependencies
Message-ID: <20130314112809.GE9189@mwanda>
References: <1363256224.1335.46.camel@x61.thuisdomein>
 <20130314105953.GJ9138@mwanda>
 <1363259393.1335.55.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363259393.1335.55.camel@x61.thuisdomein>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 14, 2013 at 12:09:53PM +0100, Paul Bolle wrote:
> On Thu, 2013-03-14 at 13:59 +0300, Dan Carpenter wrote:
> > Your patch is fine as is, but if you wanted to send a follow on
> > patch to break the depend mess into separate lines, that would also
> > be welcome.  :)
> 
> Well, now that you somehow managed to review this patch the urge to
> clean this line up has suddenly diminished. But maybe you're lucky and
> this will not pass Greg. 
> 

This CCG driver was mentioned in the latest lwn kernel page so I was
just looking at it.  And I looked at it for a minute or two.  And
then I started backing away slowly...  :P

regards,
dan carpenter

