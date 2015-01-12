Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753156AbbALOOX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 09:14:23 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:62555 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752108AbbALOOW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 09:14:22 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19eXLvS377S70A6E3yPZC3dW0Gv59Qx984=
X-DKIM: OpenDKIM Filter v2.0.1 titan 1B82E6440BD
Date: Mon, 12 Jan 2015 09:14:18 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Arno Tiemersma <arno.tiemersma@gmail.com>
Cc: gregkh@linuxfoundation.org, jake@lwn.net, antonysaraev@gmail.com,
        eric.rost@mybabylon.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: skein: Fix checkpatch warnings
Message-ID: <20150112141418.GW24989@titan.lakedaemon.net>
References: <1420902047-7569-1-git-send-email-arno.tiemersma@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420902047-7569-1-git-send-email-arno.tiemersma@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arno,

On Sat, Jan 10, 2015 at 04:00:47PM +0100, Arno Tiemersma wrote:
> Remove do {} while (0) loops around single statements in
> skein/skein_block.c
> 
> Signed-off-by: Arno Tiemersma <arno.tiemersma@gmail.com>
> ---
>  drivers/staging/skein/skein_block.c | 16 ++++------------
>  1 file changed, 4 insertions(+), 12 deletions(-)

Is this a V2?  Several people have been submitting patches for this
checkpatch issue.  Please check the staging ML and deconflict with other
submitters.

thx,

Jason.
