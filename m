Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752701Ab3KCIST (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Nov 2013 03:18:19 -0500
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:42876 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752101Ab3KCISS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Nov 2013 03:18:18 -0500
X-Originating-IP: 109.242.2.94
Date: Sun, 3 Nov 2013 10:18:11 +0200
From: Aldo Iljazi <mail@aldo.io>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: marek.belisko@gmail.com, devel@driverdev.osuosl.org,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: ft1000: fixed coding style issues
Message-ID: <20131103081811.GA7025@linux>
References: <1383426232-24686-1-git-send-email-mail@aldo.io>
 <20131102211820.GA24821@linux>
 <20131103063049.GI26669@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131103063049.GI26669@mwanda>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Dan Carpenter wrote:

> On Sat, Nov 02, 2013 at 11:18:20PM +0200, Aldo Iljazi wrote:
> >  Aldo Iljazi wrote:
> > 
> > > Fixed a few coding style issues that checkpatch reported.
> > > 
> > > Specifically:
> > > 
> > > 1. line over 80 characters issue on the lines 9 and 10.
> > > 2. space prohibited before open square bracket '[' issue on the lines
> > > 31.
> > > 3. inserted space after comma on lines 32 to 156.
> > > 
> > > Signed-off-by: Aldo Iljazi <mail@aldo.io>
> 
> This file is easy to review so you may as well fix all the issues.
> 
> Clean up the license block so it's in the normal format.  Put the commas
> at the end of the line instead of the beginning.
> 
> regards,
> dan carpenter
> 

Okay I'll resend later.
-- 
Aldo Iljazi
