Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754735Ab3LDHjl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 02:39:41 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:27250 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753747Ab3LDHjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 02:39:39 -0500
Date: Wed, 4 Dec 2013 10:38:25 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Aldo Iljazi <mail@aldo.io>
Cc: Samuel Thibault <samuel.thibault@ens-lyon.org>, w.d.hubbs@gmail.com,
        chris@the-brannons.com, kirk@reisers.ca, gregkh@linuxfoundation.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Joe Perches <joe@perches.com>, Andy Whitcroft <apw@canonical.com>
Subject: Re: [PATCH] Staging: speakup: synth.c: removed a space
Message-ID: <20131204073824.GP28413@mwanda>
References: <1386101283-14650-1-git-send-email-mail@aldo.io>
 <20131203221703.GE8138@type>
 <20131204043515.GB6909@linux>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131204043515.GB6909@linux>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 04, 2013 at 06:35:15AM +0200, Aldo Iljazi wrote:
>  Samuel Thibault wrote:
> 
> > Err, I'd rather make it really visible that the for loop doesn't have
> > its first statement?
> 
> Wouldn't it be better if you add a comment there? So it would follow the
> coding style?

No.  Adding obvious comments is more annoying than the space.

This seems like a small bug in checkpatch.pl.  Joe, the problem is this
code:

	for ( ; x; x++) {

It's complaining about the space character before the semicolon.

regards,
dan carpenter
