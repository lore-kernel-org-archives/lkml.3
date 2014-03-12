Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752135AbaCLUAM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 16:00:12 -0400
Received: from gate.crashing.org ([63.228.1.57]:43479 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751070AbaCLUAK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 16:00:10 -0400
Message-ID: <1394654396.4840.94.camel@pasglop>
Subject: Re: linux-next: build failure after merge of the driver-core tree
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Mark Brown <broonie@kernel.org>
Cc: Greg KH <greg@kroah.com>, Stewart Smith <stewart@linux.vnet.ibm.com>,
        Tejun Heo <tj@kernel.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 13 Mar 2014 06:59:56 +1100
In-Reply-To: <20140312113742.GM28112@sirena.org.uk>
References: <20140312005152.9ac4063f65dbd233f5d50b4d@kernel.org>
	 <20140312015021.GC10106@kroah.com> <1394596541.4840.70.camel@pasglop>
	 <20140312113742.GM28112@sirena.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.11.90 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-03-12 at 11:37 +0000, Mark Brown wrote:
> On Wed, Mar 12, 2014 at 02:55:41PM +1100, Benjamin Herrenschmidt wrote:
> 
> > How do you suggest we proceed ? I can't add a fix to powerpc-next to use
> > the new function since it doesn't exist upstream yet. I would have to
> > pull drivers-core-next in which I really don't want to do....
> 
> > Can the removal of the function be delayed to -rc1 so we can properly
> > do the fixup ? Or do you have the introduction of the new function in
> > a topic branch I can pull in without the rest of drivers-core-next ?
> 
> The delay would have been my first suggestion - otherwise I'd not be
> surprised to see this coming up again.  Perhaps change to tagging the
> APIs as deprecated for now (so any futher new users get flagged up)
> would help.
 
Either that or I can put a copy of the patch that introduces the new
function in my tree as long as it's a single patch. The resulting
conflict should resolve trivially and Linus should be fine if
appropriate explanations are provided (though I would have preferred
pulling in a topic branch).

Greg, how do you want to proceed ?

Cheers,
Ben.


