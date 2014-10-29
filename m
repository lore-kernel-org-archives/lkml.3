Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756347AbaJ2Rvr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 13:51:47 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:63419 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145AbaJ2Rvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 13:51:45 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19mqT4kM0X2eawS0FZd3V/J8I04G8ULl8Y=
X-DKIM: OpenDKIM Filter v2.0.1 titan 4A1B060BFFD
Date: Wed, 29 Oct 2014 13:51:37 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Mikael Svantesson <mikael@distopic.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jake Edge <jake@lwn.net>,
        Anton Saraev <antonysaraev@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: skein: skein_api.c: removed space before ','
Message-ID: <20141029175137.GI15252@titan.lakedaemon.net>
References: <54510E1F.3050801@distopic.net>
 <1414601738-11968-1-git-send-email-mikael@distopic.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414601738-11968-1-git-send-email-mikael@distopic.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mikael,

On Wed, Oct 29, 2014 at 05:55:34PM +0100, Mikael Svantesson wrote:
> Signed-off-by: Mikael Svantesson <mikael@distopic.net>
> ---
>  drivers/staging/skein/skein_api.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Acked-by: Jason Cooper <jason@lakedaemon.net>

For future patches, please remember to add the 'V3' to the subject like
you did for v2.

thx,

Jason.
