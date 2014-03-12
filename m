Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752194AbaCLUCi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 16:02:38 -0400
Received: from mail-qc0-f172.google.com ([209.85.216.172]:40543 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151AbaCLUCh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 16:02:37 -0400
Date: Wed, 12 Mar 2014 16:02:32 -0400
From: Tejun Heo <tj@kernel.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Mark Brown <broonie@kernel.org>, Greg KH <greg@kroah.com>,
        Stewart Smith <stewart@linux.vnet.ibm.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the driver-core tree
Message-ID: <20140312200232.GA22332@htj.dyndns.org>
References: <20140312005152.9ac4063f65dbd233f5d50b4d@kernel.org>
 <20140312015021.GC10106@kroah.com>
 <1394596541.4840.70.camel@pasglop>
 <20140312113742.GM28112@sirena.org.uk>
 <1394654396.4840.94.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394654396.4840.94.camel@pasglop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 13, 2014 at 06:59:56AM +1100, Benjamin Herrenschmidt wrote:
> Either that or I can put a copy of the patch that introduces the new
> function in my tree as long as it's a single patch. The resulting
> conflict should resolve trivially and Linus should be fine if
> appropriate explanations are provided (though I would have preferred
> pulling in a topic branch).

An alternative that I personally prefer to resolve conflicts like this
is to pull driver-core-next into the broken tree and resolve it there.
It's highly likely that the pending changes are gonna be included in
the next merge window.  If contaminating the merge history is a
concern, it can live in a separate branch which is pulled into
for-next.

Thanks.

-- 
tejun
