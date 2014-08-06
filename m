Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705AbaHFWjT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 18:39:19 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:56635 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753608AbaHFWjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 18:39:17 -0400
X-Originating-IP: 173.246.103.110
Date: Wed, 6 Aug 2014 15:39:10 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: David Rientjes <rientjes@google.com>
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org,
        "Luis R. Rodriguez" <mcgrof@suse.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] x86, platform, kconfig: move kvmconfig functionality
 to a helper
Message-ID: <20140806223909.GA14575@jtriplet-mobl1>
References: <20140806222419.GA2566@jtriplet-mobl1>
 <20140806223032.GA3517@jtriplet-mobl1>
 <alpine.DEB.2.02.1408061532120.13545@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1408061532120.13545@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 06, 2014 at 03:33:45PM -0700, David Rientjes wrote:
> On Wed, 6 Aug 2014, Josh Triplett wrote:
> > The new mergeconfig helper makes it easier to add other partial
> > configurations similar to kvmconfig.
> > 
> > Based on a patch by Luis R. Rodriguez <mcgrof@suse.com>.
> > Originally-Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
> > 
> > Modified to make the helper name more general than just virtualization,
> > and factor out more of the common file path.
> > 
> > Signed-off-by: Josh Triplett <josh@joshtriplett.org>
> 
> For the original patch from Luis:
> Suggested-by: David Rientjes <rientjes@google.com>
> 
> For this patch:
> Acked-by: David Rientjes <rientjes@google.com>
> 
> Thanks for generalizing this part of the Makefile, after it's merged it 
> will make Luis's set reduce down to a single change.

Thank you as well for suggesting this refactoring; I should have thought
to do the same rather than copying and pasting the contents of
kvmconfig.

Should this go in via Andrew's -mm tree, or via tip for x86?

- Josh Triplett
