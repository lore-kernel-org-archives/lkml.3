Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755709AbaDVKGL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 06:06:11 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:60130 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755241AbaDVKGJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 06:06:09 -0400
Date: Tue, 22 Apr 2014 12:06:08 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: hans.verkuil@cisco.com, m.chehab@samsung.com, ext-eero.nurkkala@nokia.com,
        nils.faerber@kernelconcepts.de, joni.lapilainen@gmail.com,
        freemangordon@abv.bg, sre@ring0.de, pali.rohar@gmail.com,
        Greg KH <greg@kroah.com>, trivial@kernel.org,
        kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] radio-bcm2048.c: fix wrong overflow check
Message-ID: <20140422100608.GA16808@amd.pavel.ucw.cz>
References: <20140420145622.GA15567@amd.pavel.ucw.cz>
 <20140422083917.GS4963@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140422083917.GS4963@mwanda>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2014-04-22 11:39:17, Dan Carpenter wrote:
> On Sun, Apr 20, 2014 at 04:56:22PM +0200, Pavel Machek wrote:
> > 
> > Fix wrong overflow check in radio-bcm2048.
> > 
> > Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
> > Signed-off-by: Pavel Machek <pavel@ucw.cz>
> 
> Signed off means like you're signing a legal document to show that you
> didn't do anything illegal when you handled the patch.  Was this patch
> authored by Pali?  If so, then use the From: header.

Who cares, it is single line. And yes, I know what signed-off-by
means, thank you.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
