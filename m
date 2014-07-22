Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753327AbaGVHAe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 03:00:34 -0400
Received: from ozlabs.org ([103.22.144.67]:44655 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751672AbaGVHAa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 03:00:30 -0400
Message-ID: <1406012425.28595.0.camel@concordia>
Subject: Re: [PATCH] powerpc: Revert removing of _INIT_GLOBAL(), _STATIC()
 and _INIT_STATIC()
From: Michael Ellerman <mpe@ellerman.id.au>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Olof Johansson <olof@lixom.net>,
        linuxppc-dev@lists.ozlabs.org, LKML <linux-kernel@vger.kernel.org>,
        Anton Blanchard <anton@samba.org>
Date: Tue, 22 Jul 2014 17:00:25 +1000
In-Reply-To: <1406009637.22200.14.camel@pasglop>
References: <20140714201204.7b6fcd8e@gandalf.local.home>
	 <1405389955.9343.48.camel@pasglop>
	 <20140721145651.465db070@gandalf.local.home>
	 <1406009637.22200.14.camel@pasglop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-07-22 at 16:13 +1000, Benjamin Herrenschmidt wrote:
> On Mon, 2014-07-21 at 14:56 -0400, Steven Rostedt wrote:
> > > Weird ... what are your gcc and binutils versions ? Smells like a
> > > toolchain issue to me but I need to dig a bit more. Doesn't hit any
> > > of my test configs here.
> > > 
> > 
> > Can you test the attached config with this toolchain and see if you get
> > the same build bug.
> 
> Yeah ok, I hit it too, it's one of those issues with the bloody
> alternate feature sections getting pushed too far away. Argh.

This should fix it temporarily at least:

  http://patchwork.ozlabs.org/patch/369950/

cheers


