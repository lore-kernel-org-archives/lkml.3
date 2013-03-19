Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757633Ab3CSUO6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 16:14:58 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:29015 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754129Ab3CSUO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 16:14:56 -0400
Date: Tue, 19 Mar 2013 21:14:54 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: David Miller <davem@davemloft.net>, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sparc: remove unused "config BITS"
Message-ID: <20130319201454.GA25072@merkur.ravnborg.org>
References: <1363708727.1390.16.camel@x61.thuisdomein> <20130319.123306.1709006318806942163.davem@davemloft.net> <1363712807.1390.26.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363712807.1390.26.camel@x61.thuisdomein>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 19, 2013 at 06:06:47PM +0100, Paul Bolle wrote:
> On Tue, 2013-03-19 at 12:33 -0400, David Miller wrote:
> > We use this in the Makefile fragments, you cannot remove it.
> 
> >From arch/sparc/Makefile:
>     ifeq ($(CONFIG_SPARC32),y)
>     [...]
> 
>     [...]
>     export BITS    := 32
>     [...]
> 
>     else
>     [...]
> 
>     [...]
>     export BITS   := 64
>     [...]
> 
> So $(BITS) is set depending on whether CONFIG_SPARC32 is set or not.
> Using $(BITS) in sparc's Makefiles is not using CONFIG_BITS. That
> doesn't count as usage of "config BITS". 
Just double checked - you are right.
Maybe send a v2 with this info in changelog and add my:

Acked-by: Sam Ravnborg <sam@ravnborg.org>

	Sam
