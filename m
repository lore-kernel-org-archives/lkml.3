Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753314AbbALOPV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 09:15:21 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:64550 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752004AbbALOPT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 09:15:19 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+OmVbTx7bUiLDoW06Re+YJb015NkPDGmE=
X-DKIM: OpenDKIM Filter v2.0.1 titan E7F066440D4
Date: Mon, 12 Jan 2015 09:15:16 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Shirish Gajera <gajerashirish@gmail.com>
Cc: gregkh@linuxfoundation.org, eric.rost@mybabylon.net, jake@lwn.net,
        antonysaraev@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] staging: skein: Remove all do{} while (0) loop from
 single statement.
Message-ID: <20150112141516.GX24989@titan.lakedaemon.net>
References: <20150111234105.GA2744@shirish-ThinkPad-Edge-E430>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150111234105.GA2744@shirish-ThinkPad-Edge-E430>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 11, 2015 at 03:41:05PM -0800, Shirish Gajera wrote:
> This patch fixes the checkpatch.pl warning:
> 
> WARNING: Single statement macros should not use a do {} while (0) loop
> 
> I remove do while from the single statement macro.
> 
> Signed-off-by: Shirish Gajera <gajerashirish@gmail.com>
> ---
>  drivers/staging/skein/skein_block.c | 31 +++++++++----------------------
>  1 file changed, 9 insertions(+), 22 deletions(-)

Several people have submitted patches for this checkpatch warning.
Please check the mailinglist archives and deconflict with the other
submitters.

thx,

Jason.
