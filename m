Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753587AbaETOsF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 10:48:05 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:59077 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753163AbaETOsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 10:48:03 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX192I1OqUFkEYUnCXjcCzAdmlIgIpctY6zQ=
X-DKIM: OpenDKIM Filter v2.0.1 titan 80F9F57AFC4
Date: Tue, 20 May 2014 10:47:57 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Jake Edge <jake@lwn.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Joe Perches <joe@perches.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Anton Saraev <antonysaraev@gmail.com>
Subject: Re: [PATCH 0/3] staging/skein: more cleanup
Message-ID: <20140520144757.GA8664@titan.lakedaemon.net>
References: <20140520075612.220a13ae@chukar.edge2.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140520075612.220a13ae@chukar.edge2.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jake,

On Tue, May 20, 2014 at 07:56:12AM -0600, Jake Edge wrote:
> 
> Clean up a few more things in skein to get it closer to mainline
> inclusion.  The first may be questionable (so I probably should have
> put it last -- oh well, I can always respin), but it seemed like
> putting all of the threefish block functions in one file, like the
> skein block functions are all in one file, made sense.

Fine by me.  For the whole series:

Acked-by: Jason Cooper <jason@lakedaemon.net>

Thanks for the help!

Do you have any other series pending for this driver?  I suspect Anton
does and I'd like to deconflict the two efforts.

thx,

Jason.
