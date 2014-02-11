Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751824AbaBKNRn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 08:17:43 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:28270 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785AbaBKNRm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 08:17:42 -0500
Date: Tue, 11 Feb 2014 16:17:47 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Martin Walch <walch.martin@web.de>, linux-kernel@vger.kernel.org,
        Richard Weinberger <richard@nod.at>
Subject: Re: [PATCH] staging: r8188eu: default to "y" in Kconfig
Message-ID: <20140211131747.GX26722@mwanda>
References: <1392121892.13064.9.camel@x220>
 <20140211125306.GW26722@mwanda>
 <1392123668.13064.23.camel@x220>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392123668.13064.23.camel@x220>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 11, 2014 at 02:01:08PM +0100, Paul Bolle wrote:
> On Tue, 2014-02-11 at 15:53 +0300, Dan Carpenter wrote:
> > You've pretty much given Martin's secret assistance away already on a
> > public mailing list.  Next time just add the Reported-by.  :P
> 
> I would have done, if I hadn't bothered to check
> Documentation/SubmittingPatches first. It contains:
>    Please note that this tag should not be added without the reporter's
>    permission, especially if the problem was not reported in a public
>    forum.
> 
> Perhaps that should read:
>    [...], unless the problem was reported in a public forum.

Or maybe:

	Please note that if the problem was reported in private then you
	should ask for permission before adding a Reported-by tag.

regards,
dan carpenter

