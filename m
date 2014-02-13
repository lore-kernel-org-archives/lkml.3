Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752508AbaBMXWe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 18:22:34 -0500
Received: from cpsmtpb-ews10.kpnxchange.com ([213.75.39.15]:58074 "EHLO
	cpsmtpb-ews10.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751031AbaBMXWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 18:22:33 -0500
Message-ID: <1392333751.29034.3.camel@x220>
Subject: Re: [PATCH] staging: r8188eu: default to "y" in Kconfig
From: Paul Bolle <pebolle@tiscali.nl>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Randy Dunlap <rdunlap@infradead.org>, devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Martin Walch <walch.martin@web.de>, linux-kernel@vger.kernel.org,
        Richard Weinberger <richard@nod.at>
Date: Fri, 14 Feb 2014 00:22:31 +0100
In-Reply-To: <20140211131747.GX26722@mwanda>
References: <1392121892.13064.9.camel@x220> <20140211125306.GW26722@mwanda>
	 <1392123668.13064.23.camel@x220> <20140211131747.GX26722@mwanda>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 Feb 2014 23:22:31.0646 (UTC) FILETIME=[780027E0:01CF2912]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-02-11 at 16:17 +0300, Dan Carpenter wrote:
> On Tue, Feb 11, 2014 at 02:01:08PM +0100, Paul Bolle wrote:
> > I would have done, if I hadn't bothered to check
> > Documentation/SubmittingPatches first. It contains:
> >    Please note that this tag should not be added without the reporter's
> >    permission, especially if the problem was not reported in a public
> >    forum.
> > 
> > Perhaps that should read:
> >    [...], unless the problem was reported in a public forum.
> 
> Or maybe:
> 
> 	Please note that if the problem was reported in private then you
> 	should ask for permission before adding a Reported-by tag.

Your suggestion is clear and to the point. Care to submit a patch? That
also gives you a chance to mock my reading of the current text.


Paul Bolle

