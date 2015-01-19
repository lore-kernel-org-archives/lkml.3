Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752147AbbASM0V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 07:26:21 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:44922 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082AbbASM0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 07:26:20 -0500
Date: Mon, 19 Jan 2015 15:25:39 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Shirish Gajera <gajerashirish@gmail.com>, devel@driverdev.osuosl.org,
        kirk@reisers.ca, rusty@rustcorp.com.au, gregkh@linuxfoundation.org,
        daeseok.youn@gmail.com, sulamiification@gmail.com,
        speakup@linux-speakup.org, aysemelikeyurtoglu@gmail.com,
        linux-kernel@vger.kernel.org, domagoj.trsan@gmail.com,
        roxanagabriela10@gmail.com, tapaswenipathak@gmail.com,
        samuel.thibault@ens-lyon.org, dilekuzulmez@gmail.com,
        sasha.levin@oracle.com, chris@the-brannons.com
Subject: Re: [PATCH] staging: speakup: Fix warning of line over 80 characters.
Message-ID: <20150119122539.GC6456@mwanda>
References: <20150118075753.GA2612@shirish-ThinkPad-Edge-E430>
 <1421574950.31046.97.camel@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421574950.31046.97.camel@decadent.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 18, 2015 at 09:55:50AM +0000, Ben Hutchings wrote:
> On Sat, 2015-01-17 at 23:57 -0800, Shirish Gajera wrote:
> > This patch fixes the checkpatch.pl warning:
> > 
> > WARNING: line over 80 characters
> > 
> > All line over 80 characters in driver/staging/speakup/* are fixed
> [...]
> 
> It is not important to fix all such warnings.  The code seems perfectly
> readable as it is.

You can't fight checkpatch (this is why I hate when checkpatch suggests
you introduce bugs).  In the end, people will keep sending these patches
until we merge one and this patch is actually pretty good.

regards,
dan carpenter

