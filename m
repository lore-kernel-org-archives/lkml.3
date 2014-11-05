Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752086AbaKEUOK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 15:14:10 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33744 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751301AbaKEUOG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 15:14:06 -0500
Date: Wed, 5 Nov 2014 21:14:05 +0100
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>, backports@vger.kernel.org,
        linux-kernel@vger.kernel.org, yann.morin.1998@free.fr, mmarek@suse.cz,
        sassmann@kpanic.de
Subject: Re: [PATCH v2 07/13] backports: split Kconfig into Kconfig.package
	and Kconfig.sources
Message-ID: <20141105201405.GQ12953@wotan.suse.de>
References: <1415157517-15442-1-git-send-email-mcgrof@do-not-panic.com> <1415157517-15442-8-git-send-email-mcgrof@do-not-panic.com> <1415174133.2589.7.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415174133.2589.7.camel@sipsolutions.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 05, 2014 at 08:55:33AM +0100, Johannes Berg wrote:
> On Tue, 2014-11-04 at 19:18 -0800, Luis R. Rodriguez wrote:
> 
> > +++ b/backport/Kconfig.package
> > @@ -0,0 +1,32 @@
> > +mainmenu "Backports from $BACKPORTED_KERNEL_NAME $BACKPORTED_KERNEL_VERSION (backports $BACKPORTS_VERSION)"
> > +
> > +config BACKPORT_DIR
> > +	string
> > +	option env="BACKPORT_DIR"
> > +config BACKPORTS_VERSION
> > +	string
> > +	option env="BACKPORTS_VERSION"
> > +config BACKPORTED_KERNEL_VERSION
> > +	string
> > +	option env="BACKPORTED_KERNEL_VERSION"
> > +config BACKPORTED_KERNEL_NAME
> > +	string
> > +	option env="BACKPORTED_KERNEL_NAME"
> > +
> > +# some hacks for when we use backports to generate a package
> > +# to build modules out of tree.
> > +#ignore-parser-package
> 
> Here you're splitting it, and I think you should just add something to
> this file to ignore it instead of the "#ignore-parser-package" thing.

Agreed, done.

 Luis
