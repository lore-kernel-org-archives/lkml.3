Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755966AbaDVNDH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 09:03:07 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:44395 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751383AbaDVNDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 09:03:03 -0400
Date: Tue, 22 Apr 2014 16:02:19 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        hans.verkuil@cisco.com, m.chehab@samsung.com,
        ext-eero.nurkkala@nokia.com, nils.faerber@kernelconcepts.de,
        joni.lapilainen@gmail.com, freemangordon@abv.bg, sre@ring0.de,
        Greg KH <greg@kroah.com>, trivial@kernel.org,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH] radio-bcm2048.c: fix wrong overflow check
Message-ID: <20140422130219.GW4963@mwanda>
References: <20140420145622.GA15567@amd.pavel.ucw.cz>
 <20140422083917.GS4963@mwanda>
 <201404221055.54799@pali>
 <20140422091656.GV4963@mwanda>
 <20140422093836.GA16686@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140422093836.GA16686@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 11:38:36AM +0200, Pavel Machek wrote:
> Feel free to resubmit the patch yourself.

No problem.  Happy to help.

regards,
dan carpenter

