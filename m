Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752336AbaERWwh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 18:52:37 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:51038 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752050AbaERWwg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 18:52:36 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18No2baKY9rtNdZq390CuTA6S2Su1nz2dA=
X-DKIM: OpenDKIM Filter v2.0.1 titan 82F42579185
Date: Sun, 18 May 2014 18:52:31 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Jake Edge <jake@lwn.net>, Anton Saraev <antonysaraev@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Joe Perches <joe@perches.com>
Subject: Re: [PATCH v2 1/1] staging/skein: rename files and clean up
 directory structure
Message-ID: <20140518225231.GW27822@titan.lakedaemon.net>
References: <20140518125615.2df48ea9@chukar.edge2.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140518125615.2df48ea9@chukar.edge2.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jake, Anton,

On Sun, May 18, 2014 at 12:56:15PM -0600, Jake Edge wrote:
> 
> Clean up file names and locations.  Get rid of include/ directory and move
> those up to the top-level.  Rename files to get rid of upper case.  Remove
> skeinBlockNo3F.c as it was unused (temporary file or something?).
> 
> Signed-off-by: Jake Edge <jake@lwn.net>
> ---

Ahh, crap.  I'm sorry.  I dropped the ball here.  A few weeks ago Anton
(in the To:) sent me a series of patches offlist doing the exact same
work this one does.  Anton sent this as part of his participation in the
Eudyptula Challenge [1].

So that series was about to be his first contribution to the Linux
Kernel.  Unfortunately, I've been wrapped around the axle with life and
hadn't had time to review his latest version yet.  It's completely my
fault.  In my defense, I did keep in touch with him and let him know I
was busy.  :)

Jake, would you mind dropping this patch and perhaps assisting me with
reviewing Anton's series?  I'll have him resend it as-is and we can go
from there.

Anton, sorry for the mixup, please resend your series as is and include
everybody in the To and Cc of this email.  I can re-send it if you like,
but I thought you might like to do the honors.  Either works for me.

thx,

Jason.

[1] http://eudyptula-challenge.org/
