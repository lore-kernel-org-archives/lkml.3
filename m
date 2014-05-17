Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751738AbaEQWnN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 18:43:13 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:43471 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897AbaEQWnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 18:43:11 -0400
Date: Sun, 18 May 2014 01:42:55 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Peter Senna Tschudin <peter.senna@gmail.com>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>,
        Thomas Renninger <trenn@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Alan Cox <alan@linux.intel.com>, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 2/4] cpupower: Remove redundant error check
Message-ID: <20140517224255.GJ15585@mwanda>
References: <1400350980-30455-2-git-send-email-peter.senna@gmail.com>
 <20140517202255.GF15585@mwanda>
 <CA+MoWDqLtr-O=VQNC7qqNUJvWkEPtVr8cw9t5sB=adQWkywLZw@mail.gmail.com>
 <20140517215615.GI16255@mwanda>
 <CA+MoWDqriZojBJAaxSjjFXEf1rpxDLqtsiuYYsRqDwtY1L6QyA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+MoWDqriZojBJAaxSjjFXEf1rpxDLqtsiuYYsRqDwtY1L6QyA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 18, 2014 at 12:31:29AM +0200, Peter Senna Tschudin wrote:
> >
> > I am currently involved in a number of threads, not just yours, where I
> > am encouraging people to replace ambiguous returns with "return 0;".
> > This is my life now.
> So maybe you like this list of 160 places in which the return variable
> is initialized and only used as parameter to return(The list look
> good, but I haven't reviewed all 160, so there could be problems):
> http://pastebin.com/5kAbCP2e

Fantastic!  :)  These things are easy to review because if it's wrong
then the compile will break.

> 
> Does it worth doing something about those trivial cases?
> 
> Do you have more examples of ambiguous returns, so I can help you hunt them?

The main thing is what your check finds.  If you know that ret is zero
then return zero.

regards,
dan carpenter

