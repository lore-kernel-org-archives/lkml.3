Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754881AbaELPyD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 11:54:03 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:41547 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753827AbaELPyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 11:54:00 -0400
Date: Mon, 12 May 2014 08:53:49 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH] powerpc: Fix "attempt to move .org backwards" error
 (again)
Message-ID: <20140512155349.GA29066@roeck-us.net>
References: <1399680478-4970-1-git-send-email-linux@roeck-us.net>
 <1399867920.17624.73.camel@pasglop>
 <5370537F.8020901@roeck-us.net>
 <1399873724.17624.80.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399873724.17624.80.camel@pasglop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 12, 2014 at 03:48:44PM +1000, Benjamin Herrenschmidt wrote:
> On Sun, 2014-05-11 at 21:52 -0700, Guenter Roeck wrote:
> > Oh well, it was worth a try. Can you give me an example for a failing
> > configuration ?
> 
> My g5 config which is close to g5_defconfig with PR KVM enabled.
> 
> In any case, see my other messages. I'm waiting for all my test builders
> to come back and if it's clear I'll post a new patch.
> 
I'll be more than happy to wait. Let me know if I can test something.

Thanks,
Guenter
