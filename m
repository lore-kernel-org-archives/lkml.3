Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752479Ab3FZV5D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 17:57:03 -0400
Received: from gate.crashing.org ([63.228.1.57]:56064 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751401Ab3FZV5A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 17:57:00 -0400
Message-ID: <1372283780.18612.31.camel@pasglop>
Subject: Re: linux-next: manual merge of the akpm tree with the powerpc tree
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Michael Neuling <mikey@neuling.org>,
        linuxppc-dev@lists.ozlabs.org
Date: Thu, 27 Jun 2013 07:56:20 +1000
In-Reply-To: <20130626141916.GA30716@redhat.com>
References: <20130626165642.8740ecb6d5d5882b06f173c8@canb.auug.org.au>
	 <1372234231.18612.6.camel@pasglop> <20130626141916.GA30716@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-06-26 at 16:19 +0200, Oleg Nesterov wrote:
> 
> You were cc'ed every time ;)
> 
> > Why didn't it go through the powerpc tree ?
> 
> Because this series needs to update any user of
> ptrace_get/put_breakpoints
> in arch/ (simply remove these calls), then change the core kernel
> code, then
> fix arch/86.

That's fine. I didn't realize that was a series, thought it was a
standalone patch I had missed.

Ben.


