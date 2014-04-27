Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751460AbaD0Wop (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 18:44:45 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:46994 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724AbaD0Woo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 18:44:44 -0400
Date: Mon, 28 Apr 2014 01:44:25 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mateusz Guzik <mguzik@redhat.com>
Cc: tiwai@suse.de, gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        Laurent Navet <laurent.navet@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: line6: fix possible overrun
Message-ID: <20140427224425.GQ26890@mwanda>
References: <1398532162-23006-1-git-send-email-laurent.navet@gmail.com>
 <20140426204704.GB17562@mguzik.redhat.com>
 <20140426213137.GM26890@mwanda>
 <20140426215945.GC17562@mguzik.redhat.com>
 <20140427173932.GP26890@mwanda>
 <20140427200042.GA23846@mguzik.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140427200042.GA23846@mguzik.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 27, 2014 at 10:00:43PM +0200, Mateusz Guzik wrote:
> > >  and a WARN_ON + -EINVAL in line6_init_audio to catch future
> > >  offenders.
> > 
> > Returning -EINVAL is a bad idea because it would break the driver
> > completely and make it unusable.
> > 
> 
> Well I would vote for returning the error anyway.

I'm trying to be polite, but you are talking about adding regressions
deliberately...

It's very rare for people to deliberately add regressions to the kernel.
I have only seen it one time before.

regards,
dan carpenter

