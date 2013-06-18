Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933590Ab3FRR60 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 13:58:26 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50484 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932872Ab3FRR6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 13:58:23 -0400
Date: Tue, 18 Jun 2013 10:58:22 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Pavel Machek <pavel@denx.de>
Cc: Grant Likely <grant.likely@secretlab.ca>, Detlev Zundel <dzu@denx.de>,
        "Hans J. Koch" <hjk@hansjkoch.de>,
        Rob Herring <rob.herring@calxeda.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        trivial <trivial@kernel.org>
Subject: Re: [PATCH] fix UIO with device tree but no assigned interrupt
Message-ID: <20130618175822.GB8386@kroah.com>
References: <20130617134957.GA15602@amd.pavel.ucw.cz>
 <CACxGe6sO6Tes8en905cyJwP69w82PHjwKV9+XxxXhAPMRyGYkA@mail.gmail.com>
 <20130618125235.GA15122@amd.pavel.ucw.cz>
 <CACxGe6tLPfJ3KS6+4aO8s8emq8=ajuc+gmBtaEDqd60m4_vx6w@mail.gmail.com>
 <20130618142634.GB17361@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130618142634.GB17361@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 18, 2013 at 04:26:34PM +0200, Pavel Machek wrote:
> 
> If device is initialized from device tree, but has no interrupt
> assigned, uio will still try to request and interrupt old way,
> fails, and fails registration.
> 
> This is wrong; don't try initializing irq using platform data if
> device tree is available.
> 
> Simplified code based on suggestion by Grant Likely.
> 
> Fixed memory leak in "irq can not be registered" error path.
> 
> Signed-off-by: Pavel Machek <pavel@denx.de>
> Reported-by: Detlev Zundel <dzu@denx.de>

I see a ton of patches in this thread, and have no idea which one is
"newest" and correct.

Please resend, in a format that I do not have to edit at all (hint, the
subject line counts), that I can apply properly.

thanks,

greg k-h
