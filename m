Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754421AbaDVIkK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 04:40:10 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:41394 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752689AbaDVIkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 04:40:08 -0400
Date: Tue, 22 Apr 2014 11:39:17 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: hans.verkuil@cisco.com, m.chehab@samsung.com, ext-eero.nurkkala@nokia.com,
        nils.faerber@kernelconcepts.de, joni.lapilainen@gmail.com,
        freemangordon@abv.bg, sre@ring0.de, pali.rohar@gmail.com,
        Greg KH <greg@kroah.com>, trivial@kernel.org,
        kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] radio-bcm2048.c: fix wrong overflow check
Message-ID: <20140422083917.GS4963@mwanda>
References: <20140420145622.GA15567@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140420145622.GA15567@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 20, 2014 at 04:56:22PM +0200, Pavel Machek wrote:
> 
> Fix wrong overflow check in radio-bcm2048.
> 
> Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
> Signed-off-by: Pavel Machek <pavel@ucw.cz>

Signed off means like you're signing a legal document to show that you
didn't do anything illegal when you handled the patch.  Was this patch
authored by Pali?  If so, then use the From: header.

Btw, I reported this bug on Dec 10 last year.  It's better that we fix
it now than not fix it at all but we could have done better.  Was the
kbuild-zero-day bug report format confusing or how could I have helped
out there?

regards,
dan carpenter

