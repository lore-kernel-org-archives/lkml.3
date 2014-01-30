Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753797AbaA3WKe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 17:10:34 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:64471 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751468AbaA3WKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 17:10:33 -0500
Date: Thu, 30 Jan 2014 17:10:29 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: nicolas.dichtel@6wind.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        stable <stable@vger.kernel.org>, Clark Williams <williams@redhat.com>,
        "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
        John Kacur <jkacur@redhat.com>, Willem de Bruijn <willemb@google.com>
Subject: Re: [PATCH 0/2] [BUG FIXES - 3.10.27] sit: More backports
Message-ID: <20140130171029.01cd80ca@gandalf.local.home>
In-Reply-To: <52EA56E1.40507@6wind.com>
References: <20140128205756.074448668@goodmis.org>
	<52E8E025.2060803@6wind.com>
	<20140129075745.4227a2ed@gandalf.local.home>
	<52E9267C.90403@6wind.com>
	<20140129154811.27fbaf13@gandalf.local.home>
	<52EA1B4B.5080403@6wind.com>
	<20140130083103.2bc68bad@gandalf.local.home>
	<52EA56E1.40507@6wind.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Jan 2014 14:42:57 +0100
Nicolas Dichtel <nicolas.dichtel@6wind.com> wrote:


> > I'll let you know when these are finished.
> Thank you for testing.

Our short tests that were crashing have all now passed :-) with your
patches applied.

We are now running our full tier tests on the code, but I don't think
we need to wait. Please add my tags to your patches, and hopefully we
can get David to give us a new blessing on your patch set.

David and Greg,

You can ignore my patches as it seems that Nicolas's patches solve the
issues we have been seeing on 3.10.

Nicolas,

Thanks for all your effort in helping us out here :-)

Reported-by: Steven Rostedt <srostedt@redhat.com>
Tested-by: Steven Rostedt <srostedt@redhat.com> (and our entire MRG team)
Tested-by: "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>
Tested-by: John Kacur <jkacur@redhat.com>

I don't usually give my Red Hat email for things like this, but as this
was found and tested with the Red Hat infrastructure, with the help
from Luis and John (and others), I would like to give them credit too.

-- Steve
