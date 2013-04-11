Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752922Ab3DKIUT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 04:20:19 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:44766 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751440Ab3DKIUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 04:20:16 -0400
Date: Thu, 11 Apr 2013 11:19:43 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Dave Jones <davej@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>, Andy Whitcroft <apw@shadowen.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>
Subject: Re: [PATCH] checkpatch: Warn on comparisons to true and false
Message-ID: <20130411081943.GA6772@mwanda>
References: <1365563834.27174.12.camel@joe-AO722>
 <20130410155751.7ecc6738d616fb8771991ce1@linux-foundation.org>
 <20130411021415.GA16118@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130411021415.GA16118@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 10, 2013 at 10:14:15PM -0400, Dave Jones wrote:
> On Wed, Apr 10, 2013 at 03:57:51PM -0700, Andrew Morton wrote:
>  > On Tue, 09 Apr 2013 20:17:14 -0700 Joe Perches <joe@perches.com> wrote:
>  > 
>  > > Comparisons of A to true and false are better written
>  > > as A and !A.
>  > > 
>  > > Bleat a message on use.
>  > 
>  > hm.  I'm counting around 1,100 instances of "== true" and "== false".
>  > 
>  > That's a lot of people to shout at.  Is it really worthwhile? 
>  > "foo==true" is a bit of a waste of space but I can't say that I find it
>  > terribly offensive.
> 
> It would be interesting to see how many people have historically screwed 
> up and used (!a) when they mean (a) and vice versa, versus spelling
> it out longform.  I'd be surprised if the results weren't skewed
> in favour of the more verbose form.

I see a the occasional reversed test in Smatch but normally these
kind of bugs are detected with basic testing so they are rare.

regards,
dan carpenter

