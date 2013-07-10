Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754864Ab3GJRgq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 13:36:46 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:34528 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754524Ab3GJRgp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 13:36:45 -0400
Message-ID: <1373477804.14604.55.camel@joe-AO722>
Subject: Re: [PATCH] firmware/dmi_scan: Drop OOM messages
From: Joe Perches <joe@perches.com>
To: Jean Delvare <jdelvare@suse.de>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Ben Hutchings <ben@decadent.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 10 Jul 2013 10:36:44 -0700
In-Reply-To: <1373473051.4399.51.camel@chaos.site>
References: <1373460424.4399.45.camel@chaos.site>
	 <1373467888.14604.32.camel@joe-AO722> <1373473051.4399.51.camel@chaos.site>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-07-10 at 18:17 +0200, Jean Delvare wrote:
> Le Wednesday 10 July 2013 à 07:51 -0700, Joe Perches a écrit :
> > even more trivial...
[]
> > It'd also be nice to use the same test style
> > in all 6 uses.
> > 
> > 	if (!foo)
> 
> Both styles are used throughout the file, and checkpatch doesn't
> complain.

And it might be wrong for checkpatch to complain as
there are tens of thousands of those in the kernel.

I think using both styles in the same file is poor
form though.

> Unifying the coding style is beyond the scope of my patchset,
> sorry. Feel free to send a patch on top of mine if you really care.

No worries.  If I remember, I'll send a patch after
yours hit -next.


