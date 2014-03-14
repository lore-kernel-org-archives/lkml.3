Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754929AbaCNSDJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 14:03:09 -0400
Received: from imap.thunk.org ([74.207.234.97]:41490 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754461AbaCNSDH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 14:03:07 -0400
Date: Fri, 14 Mar 2014 14:02:58 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Joe Perches <joe@perches.com>
Cc: Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>, virtio-dev@lists.oasis-open.org,
        virtualization@lists.linux-foundation.org, fes@google.com
Subject: Re: [PATCH] virtio-blk: make the queue depth configurable
Message-ID: <20140314180258.GA29201@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Joe Perches <joe@perches.com>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	Rusty Russell <rusty@rustcorp.com.au>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	virtio-dev@lists.oasis-open.org,
	virtualization@lists.linux-foundation.org, fes@google.com
References: <1394818263-29947-1-git-send-email-tytso@mit.edu>
 <1394818720.3253.1.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394818720.3253.1.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 14, 2014 at 10:38:40AM -0700, Joe Perches wrote:
> > +static int queue_depth = 64;
> > +module_param(queue_depth, int, 444);
> 
> 444?  Really Ted?

Oops, *blush*.   Thanks for catching that.

					- Ted
