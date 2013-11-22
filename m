Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755287Ab3KVJaa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 04:30:30 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:30679 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752190Ab3KVJa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 04:30:28 -0500
X-IronPort-AV: E=Sophos;i="4.93,751,1378857600"; 
   d="scan'208";a="74687533"
Message-ID: <1385112625.25845.6.camel@kazak.uk.xensource.com>
Subject: Re: [Xen-devel] [PATCH 4/4] xen/xenbus: Avoid synchronous wait on
 XenBus stalling shutdown/restart.
From: Ian Campbell <Ian.Campbell@citrix.com>
To: David Vrabel <david.vrabel@citrix.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        <xen-devel@lists.xenproject.org>, <linux-kernel@vger.kernel.org>,
        <JBeulich@suse.com>, <boris.ostrovsky@oracle.com>
Date: Fri, 22 Nov 2013 09:30:25 +0000
In-Reply-To: <528E485C.5030906@citrix.com>
References: <1383932286-25080-1-git-send-email-konrad.wilk@oracle.com>
	 <1383932286-25080-5-git-send-email-konrad.wilk@oracle.com>
	 <528E485C.5030906@citrix.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.80]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

graft 8 <20130528152156.GB3027@phenom.dumpdata.com>
prune 8 <20130528181149.GA27718@phenom.dumpdata.com>
thanks

On Thu, 2013-11-21 at 17:52 +0000, David Vrabel wrote:
> > Fixes-Bug: http://bugs.xenproject.org/xen/bug/8
> 
> This bug link has no useful information in it.

Looks like the intention was for it to reference this mail:
http://thread.gmane.org/gmane.comp.emulators.xen.devel/160720/focus=160828
this has the exact same contents as the control mail that created this
bug which I dug out of the bug trackers spool. The probles was that in
the original the commands were appended instead of at the front of the
message, so they got ignored. Then when the commands were correctly sent
the mail in question used "!" (meaning this mail) but didn't go to
xen-devel, so it didn't actually refer to a known thread. The correct
thing to do in that resend would have been to reference the relevant
message id directly.

I think I've fixed it up with the above commands.

Ian.

