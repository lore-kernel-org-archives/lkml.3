Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752237AbaLCNBm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 08:01:42 -0500
Received: from down.free-electrons.com ([37.187.137.238]:40158 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751061AbaLCNBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 08:01:41 -0500
Date: Wed, 3 Dec 2014 14:01:36 +0100
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Michael Ellerman <mpe@ellerman.id.au>
Cc: Tim Bird <tim.bird@sonymobile.com>, Shuah Khan <shuahkh@osg.samsung.com>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        Josh Triplett <josh@joshtriplett.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-embedded@vger.kernel.org" <linux-embedded@vger.kernel.org>
Subject: Re: [PATCH v5] selftest: size: Add size test for Linux kernel
Message-ID: <20141203140136.12997331@free-electrons.com>
In-Reply-To: <1417578191.16722.11.camel@concordia>
References: <547E854E.5060101@sonymobile.com>
	<1417578191.16722.11.camel@concordia>
Organization: Free Electrons
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael, Tim,

On Wed, 03 Dec 2014 14:43:11 +1100, Michael Ellerman wrote:

> > diff --git a/tools/testing/selftests/size/Makefile b/tools/testing/selftests/size/Makefile
> > new file mode 100644
> > index 0000000..47f8e9c
> > --- /dev/null
> > +++ b/tools/testing/selftests/size/Makefile
> > @@ -0,0 +1,15 @@
> > +#ifndef CC
> > +	CC = $(CROSS_COMPILE)gcc
> > +#endif
> 
> I think the following is preferable:
> 
>   CC := $(CROSS_COMPILE)$(CC)

It is even more necessary that #ifndef and #endif don't exist in make.
They are just comments, and therefore, ignored. Seems like Tim does too
much C :-)

Best regards,

Thomas
-- 
Thomas Petazzoni, CTO, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
