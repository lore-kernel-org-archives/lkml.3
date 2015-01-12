Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753329AbbALOeH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 09:34:07 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:21866 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823AbbALOeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 09:34:05 -0500
Date: Mon, 12 Jan 2015 17:33:47 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Jason Cooper <jason@lakedaemon.net>
Cc: Arno Tiemersma <arno.tiemersma@gmail.com>, devel@driverdev.osuosl.org,
        eric.rost@mybabylon.net, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, jake@lwn.net, antonysaraev@gmail.com
Subject: Re: [PATCH] staging: skein: Fix checkpatch warnings
Message-ID: <20150112143347.GE7568@mwanda>
References: <1420902047-7569-1-git-send-email-arno.tiemersma@gmail.com>
 <20150112141418.GW24989@titan.lakedaemon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150112141418.GW24989@titan.lakedaemon.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2015 at 09:14:18AM -0500, Jason Cooper wrote:
> Arno,
> 
> On Sat, Jan 10, 2015 at 04:00:47PM +0100, Arno Tiemersma wrote:
> > Remove do {} while (0) loops around single statements in
> > skein/skein_block.c
> > 
> > Signed-off-by: Arno Tiemersma <arno.tiemersma@gmail.com>
> > ---
> >  drivers/staging/skein/skein_block.c | 16 ++++------------
> >  1 file changed, 4 insertions(+), 12 deletions(-)
> 
> Is this a V2?  Several people have been submitting patches for this
> checkpatch issue.  Please check the staging ML and deconflict with other
> submitters.

Why would it be a v2?

It's really normal to get a wave of people sending the exact same patch.
There was one time where 7 people deleted the same whitespace in
panel.c.

Don't worry too much about conflicts.  It either applies when Greg reads
it or it doesn't and he kicks off an email.  Not a big deal.

regards,
dan carpenter
