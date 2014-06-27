Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752571AbaF0Csj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 22:48:39 -0400
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:17177 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752337AbaF0Csi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 22:48:38 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Al9BALfarFN5LEioPGdsb2JhbABbgw2IUaMNAQEBAQEBBplqAYEIFwQBAQEBODWEAwEBBTocIxAIAw4KCSUPBSUDBxoTiEHCXxcXhU2JHAeEQwWaWJdKKw
Date: Fri, 27 Jun 2014 12:48:34 +1000
From: Dave Chinner <david@fromorbit.com>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Thomas Knauth <thomas.knauth@gmx.de>, David Rientjes <rientjes@google.com>,
        Maksym Planeta <mcsim.planeta@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sysctl: Add a feature to drop caches selectively
Message-ID: <20140627024834.GX9508@dastard>
References: <1403626213-7691-1-git-send-email-mcsim.planeta@gmail.com>
 <alpine.DEB.2.02.1406241458140.29176@chino.kir.corp.google.com>
 <1403677528.7903.103.camel@sauron.fi.intel.com>
 <CABhLV03_PNFiwsvt+yitcsKxz5TeVECCFavdNkbgQ+XzQqASaw@mail.gmail.com>
 <20140626010606.GT4453@dastard>
 <1403763199.20275.39.camel@sauron.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403763199.20275.39.camel@sauron.fi.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2014 at 09:13:19AM +0300, Artem Bityutskiy wrote:
> On Thu, 2014-06-26 at 11:06 +1000, Dave Chinner wrote:
> > Your particular use case can be handled by directing your benchmark
> > at a filesystem mount point and unmounting the filesystem in between 
> > benchmark runs. There is no ned to adding kernel functionality for
> > somethign that can be so easily acheived by other means, especially
> > in benchmark environments where *everything* is tightly controlled.
> 
> If I was a benchmark writer, I would not be willing running it as root
> to be able to mount/unmount, I would not be willing to require the
> customer creating special dedicated partitions for the benchmark,
> because this is too user-unfriendly. Or do I make incorrect assumptions?

Just add the dev/mntpt to /etc/fstab and add "user" to the
configuration and the need for root goes away.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
