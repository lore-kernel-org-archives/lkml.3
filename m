Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752486AbaCLUPJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 16:15:09 -0400
Received: from gate.crashing.org ([63.228.1.57]:52890 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752069AbaCLUPG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 16:15:06 -0400
Message-ID: <1394655292.4840.97.camel@pasglop>
Subject: Re: linux-next: build failure after merge of the driver-core tree
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Tejun Heo <tj@kernel.org>
Cc: Mark Brown <broonie@kernel.org>, Greg KH <greg@kroah.com>,
        Stewart Smith <stewart@linux.vnet.ibm.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 13 Mar 2014 07:14:52 +1100
In-Reply-To: <20140312200232.GA22332@htj.dyndns.org>
References: <20140312005152.9ac4063f65dbd233f5d50b4d@kernel.org>
	 <20140312015021.GC10106@kroah.com> <1394596541.4840.70.camel@pasglop>
	 <20140312113742.GM28112@sirena.org.uk> <1394654396.4840.94.camel@pasglop>
	 <20140312200232.GA22332@htj.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.11.90 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-03-12 at 16:02 -0400, Tejun Heo wrote:
> On Thu, Mar 13, 2014 at 06:59:56AM +1100, Benjamin Herrenschmidt wrote:
> > Either that or I can put a copy of the patch that introduces the new
> > function in my tree as long as it's a single patch. The resulting
> > conflict should resolve trivially and Linus should be fine if
> > appropriate explanations are provided (though I would have preferred
> > pulling in a topic branch).
> 
> An alternative that I personally prefer to resolve conflicts like this
> is to pull driver-core-next into the broken tree and resolve it there.
> It's highly likely that the pending changes are gonna be included in
> the next merge window.  If contaminating the merge history is a
> concern, it can live in a separate branch which is pulled into
> for-next.

It's generally consider bad taste to pull entire trees into each
other :-) I know Stephen isn't fan of it...

I'd rather have just that series (or even better, just the patches
introducing the new function) in a topic branch, itself pulled into
both driver-core-next and my tree.

Can you produce that ? (I need a non-rebase guarantee though).

Cheers,
Ben.


