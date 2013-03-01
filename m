Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751988Ab3CAUhq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 15:37:46 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:37345 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751140Ab3CAUhp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 15:37:45 -0500
Message-ID: <1362170264.2116.24.camel@joe-AO722>
Subject: Re: [PATCH V2] MAINTAINERS: Update SIMTEC file patterns, remove
 Vincent Sanders
From: Joe Perches <joe@perches.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Simtec Linux Team <linux@simtec.co.uk>,
        Ben Dooks <ben-linux@fluff.org>,
        Cesar Eduardo Barros <cesarb@cesarb.net>
Date: Fri, 01 Mar 2013 12:37:44 -0800
In-Reply-To: <1362169225.20156.6.camel@x61.thuisdomein>
References: <1362166088.2116.10.camel@joe-AO722>
	 <1362168132.2116.17.camel@joe-AO722>
	 <1362169225.20156.6.camel@x61.thuisdomein>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-03-01 at 21:20 +0100, Paul Bolle wrote:
> On Fri, 2013-03-01 at 12:02 -0800, Joe Perches wrote:
> > commit 85fd6d6 ("ARM: S3C2410: move mach-s3c2410/* into mach-s3c24xx/")
> > moved the files, update the F: patterns.
> 
> The BAST MAINTAINER entry has come up a few times already. I commented
> on the last time that happened in https://lkml.org/lkml/2012/11/24/96 .
> Nothing has changed. I suggest to remove this entry entirely.

Seems sensible to me.  Ben?

I'm a bit surprised that all of Cesar Eduardo Barros' patches
to MAINTAINERS weren't applied.  I thought they were.  It
seems that only some of them are in.

https://lkml.org/lkml/2012/11/23/439

Cesar?  Can you please resend whatever scraps weren't applied
and make sure you cc Andrew Morton?

> I guess the CATS entry might also be removed. But that doesn't have an
> F: pattern, so I'm not sure what code that entry covers.

I believe it's basically arch/arm/mach-footbridge/cats-*


