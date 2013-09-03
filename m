Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932278Ab3ICAgO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 20:36:14 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:52079 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753871Ab3ICAgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 20:36:13 -0400
X-Originating-IP: 50.43.39.152
Date: Mon, 2 Sep 2013 17:36:03 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Shilong Wang <wangshilong1991@gmail.com>
Cc: Joe Perches <joe@perches.com>, David Howells <dhowells@redhat.com>,
        Andy Whitcroft <apw@canonical.com>,
        ksummit-2013-discuss@lists.linuxfoundation.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [Ksummit-2013-discuss] [PATCH] checkpatch: Add comment about
 updating Documentation/CodingStyle
Message-ID: <20130903003602.GB1614@leaf>
References: <20130902195056.GB32628@leaf>
 <9976.1378132260@warthog.procyon.org.uk>
 <1378138205.1953.66.camel@joe-AO722>
 <20130902181510.GA29787@leaf>
 <20130902181856.GB29787@leaf>
 <20130902153945.6d7e510c@samsung.com>
 <1378148367.1953.98.camel@joe-AO722>
 <13834.1378155023@warthog.procyon.org.uk>
 <1378156296.1953.117.camel@joe-AO722>
 <CAP9B-Q=xO8Rw_wD-tER2U1g4fKfiy01eT7rMAV6V_gCCNpy09Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAP9B-Q=xO8Rw_wD-tER2U1g4fKfiy01eT7rMAV6V_gCCNpy09Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 03, 2013 at 08:26:21AM +0800, Shilong Wang wrote:
> 2013/9/3 Joe Perches <joe@perches.com>:
> > Wang Shilong <wangshilong1991@gmail.com>
> > sent me an automated checkpatch email I
> > thought was not useful.
> 
> I am sorry if i give you any trouble, i have disabled it(in fact, it
> only has run for a day!)

I would suggest that you leave it running, but rather than sending mails
directly, have it prep the mails for you to send after manual review.
Do some careful scrutiny for false positives and cases where the change
would not improve the code, and use checkpatch's options to turn off
the more contentious warnings (like the 80-column warning).  Over time,
you'll develop a set of options that produce warnings people mostly
*want* to get notified about.

- Josh Triplett
