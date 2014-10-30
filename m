Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759957AbaJ3NS7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 09:18:59 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:54940 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759887AbaJ3NS5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 09:18:57 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/bHQZI6/qDcXwYeS4l/eLkQtUq+i1+Wuo=
X-DKIM: OpenDKIM Filter v2.0.1 titan 3ABC160CB72
Date: Thu, 30 Oct 2014 09:18:52 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Eric Rost <eric.rost@mybabylon.net>
Cc: gregkh@linuxfoundation.org, jake@lwn.net, antonysaraev@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/1] staging: skein: Removes skein_debug include
Message-ID: <20141030131852.GJ15252@titan.lakedaemon.net>
References: <20141030001207.GA5219@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141030001207.GA5219@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2014 at 07:12:08PM -0500, Eric Rost wrote:
> Removes skein_debug.h include since skein_debug.h is nonexistent.
> Removes unneeded debug empty macro defines and their uses.
> 
> Signed-off-by: Eric Rost <eric.rost@mybabylon.net>
> ---
>  drivers/staging/skein/skein_base.c  | 18 -------------
>  drivers/staging/skein/skein_base.h  | 17 -------------
>  drivers/staging/skein/skein_block.c | 51 +------------------------------------
>  3 files changed, 1 insertion(+), 85 deletions(-)

Well done, Eric.

Reviewed-by: Jason Cooper <jason@lakedaemon.net>

thx,

Jason.
