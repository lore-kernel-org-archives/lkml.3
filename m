Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757297AbaGWL47 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 07:56:59 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:42136 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753413AbaGWL45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 07:56:57 -0400
Date: Wed, 23 Jul 2014 14:56:47 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch] checkpatch: warn on missing spaces in broken up quoted
 strings
Message-ID: <20140723115647.GQ13737@mwanda>
References: <20140613065346.GA28134@mwanda>
 <1402651822.12385.31.camel@joe-AO725>
 <20140613094651.GF5015@mwanda>
 <1402689145.4462.13.camel@joe-AO725>
 <20140616064053.GJ5015@mwanda>
 <1402943256.3182.2.camel@joe-AO725>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402943256.3182.2.camel@joe-AO725>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 16, 2014 at 11:27:36AM -0700, Joe Perches wrote:
> > > Likely the \\[a-zA-Z] check should include
> > > all the tests that the multiple line string exceptions use.
> > > 
> > > (?:\\(?:[ntr]|[0-7]{1,3}|x[0-9a-fA-F]{1,2})|;\s*|\{\s*)"\s*$
> > 
> > That kind of complicate regex hurts my head.  How do I make it not
> > complain about:
> > 		"foo\n\t"
> > 		"bar";
> 
> Did you try it?
> 

Of course I tried it...  I certainly am not able to *read* it.  :P
I think that I don't know what you meant?  Just give me a whole patch I
can apply.

I also tested my version against patches and not just whole files and it
seems to work fine.

regards,
dan carpenter

