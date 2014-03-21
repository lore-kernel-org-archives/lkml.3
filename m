Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934014AbaCUNgt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 09:36:49 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43500 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933502AbaCUNgp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 09:36:45 -0400
Date: Fri, 21 Mar 2014 14:36:42 +0100
From: Jean Delvare <jdelvare@suse.de>
To: Andi Kleen <andi@firstfloor.org>
Cc: Joe Perches <joe@perches.com>, Andy Whitcroft <apw@canonical.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: checkpatch on Kconfig files
Message-ID: <20140321143642.404183e5@endymion.delvare>
In-Reply-To: <20140321132121.GL22728@two.firstfloor.org>
References: <20140321094239.18aebf02@endymion.delvare>
	<1395392257.7776.74.camel@joe-AO722>
	<20140321132121.GL22728@two.firstfloor.org>
Organization: SUSE Linux
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

On Fri, 21 Mar 2014 14:21:21 +0100, Andi Kleen wrote:
> > I believe that was Andi Kleen's pet peeve,
> > so I'll punt it back to him.
> 
> This was always in checkpatch. If you touch/move some existing
> code it blames you for the issues that were already there.
> 
> Not specific to this check.

Actually it is. I was not moving the Kconfig entry, and I was not
touching its help text either. Here checkpatch complained about
something which was in the context of the patch, not in added or
modified lines. I am not aware of any other check doing that,
thankfully.

If I obeyed to checkpatch and "fixed" the help text to make it happy,
the reviewer would have (rightfully) rejected my patch as mixing
unrelated changes together.

> If you disagree with the warnings just ignore them.

This is a false positive, and checkpatch explicitly asks for these to
be reported. Which is what I'm doing. Better tools make future
contributions better and easier.

-- 
Jean Delvare
SUSE L3 Support
