Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752052AbaELWNj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 18:13:39 -0400
Received: from gate.crashing.org ([63.228.1.57]:49467 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751406AbaELWNi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 18:13:38 -0400
Message-ID: <1399932804.17624.141.camel@pasglop>
Subject: Re: [PATCH] powerpc: Fix "attempt to move .org backwards" error
 (again)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Paul Mackerras <paulus@samba.org>
Date: Tue, 13 May 2014 08:13:24 +1000
In-Reply-To: <20140512155349.GA29066@roeck-us.net>
References: <1399680478-4970-1-git-send-email-linux@roeck-us.net>
	 <1399867920.17624.73.camel@pasglop> <5370537F.8020901@roeck-us.net>
	 <1399873724.17624.80.camel@pasglop> <20140512155349.GA29066@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.11.90 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-05-12 at 08:53 -0700, Guenter Roeck wrote:
> On Mon, May 12, 2014 at 03:48:44PM +1000, Benjamin Herrenschmidt wrote:
> > On Sun, 2014-05-11 at 21:52 -0700, Guenter Roeck wrote:
> > > Oh well, it was worth a try. Can you give me an example for a failing
> > > configuration ?
> > 
> > My g5 config which is close to g5_defconfig with PR KVM enabled.
> > 
> > In any case, see my other messages. I'm waiting for all my test builders
> > to come back and if it's clear I'll post a new patch.
> > 
> I'll be more than happy to wait. Let me know if I can test something.

http://patchwork.ozlabs.org/patch/347892/

Cheers,
Ben.


