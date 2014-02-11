Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751464AbaBKMxD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 07:53:03 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:51411 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785AbaBKMxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 07:53:01 -0500
Date: Tue, 11 Feb 2014 15:53:06 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, Richard Weinberger <richard@nod.at>,
        Martin Walch <walch.martin@web.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: r8188eu: default to "y" in Kconfig
Message-ID: <20140211125306.GW26722@mwanda>
References: <1392121892.13064.9.camel@x220>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392121892.13064.9.camel@x220>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 11, 2014 at 01:31:32PM +0100, Paul Bolle wrote:
> Two Kconfig entries for this driver default to (uppercase) "Y". But in
> Kconfig (lowercase) "y" is a magic symbol. "Y" is an ordinary symbol.
> As "Y" is never set these Kconfig symbols will also not be set by
> default.
> 
> So use "default y" here, as was clearly intended.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> This patch will enable code that used to be disabled. Since this is in
> staging, that should be OK. This might also uncover warnings or errors.
> I didn't test it, anyhow.
> 
> This patch also deserves a
>     Reported-by: Martin Walch <walch.martin@web.de>
> 
> line, but that apparently requires Martin's permission.
> 

You've pretty much given Martin's secret assistance away already on a
public mailing list.  Next time just add the Reported-by.  :P

regards,
dan carpenter

