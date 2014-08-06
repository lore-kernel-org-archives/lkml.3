Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754520AbaHFWnB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 18:43:01 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:35605 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753533AbaHFWm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 18:42:59 -0400
Date: Wed, 6 Aug 2014 15:42:57 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Josh Triplett <josh@joshtriplett.org>
cc: akpm@linux-foundation.org, torvalds@linux-foundation.org,
        "Luis R. Rodriguez" <mcgrof@suse.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] x86, platform, kconfig: move kvmconfig functionality
 to a helper
In-Reply-To: <20140806223909.GA14575@jtriplet-mobl1>
Message-ID: <alpine.DEB.2.02.1408061542140.13545@chino.kir.corp.google.com>
References: <20140806222419.GA2566@jtriplet-mobl1> <20140806223032.GA3517@jtriplet-mobl1> <alpine.DEB.2.02.1408061532120.13545@chino.kir.corp.google.com> <20140806223909.GA14575@jtriplet-mobl1>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Aug 2014, Josh Triplett wrote:

> > > The new mergeconfig helper makes it easier to add other partial
> > > configurations similar to kvmconfig.
> > > 
> > > Based on a patch by Luis R. Rodriguez <mcgrof@suse.com>.
> > > Originally-Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
> > > 
> > > Modified to make the helper name more general than just virtualization,
> > > and factor out more of the common file path.
> > > 
> > > Signed-off-by: Josh Triplett <josh@joshtriplett.org>
> > 
> > For the original patch from Luis:
> > Suggested-by: David Rientjes <rientjes@google.com>
> > 
> > For this patch:
> > Acked-by: David Rientjes <rientjes@google.com>
> > 
> > Thanks for generalizing this part of the Makefile, after it's merged it 
> > will make Luis's set reduce down to a single change.
> 
> Thank you as well for suggesting this refactoring; I should have thought
> to do the same rather than copying and pasting the contents of
> kvmconfig.
> 
> Should this go in via Andrew's -mm tree, or via tip for x86?
> 

The answer could be "both", if Ingo doesn't pick it up then Andrew 
sometimes picks it up and sends them along later.
