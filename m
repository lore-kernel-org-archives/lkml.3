Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932684AbaEENeg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 09:34:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42444 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932581AbaEENee (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 09:34:34 -0400
Date: Mon, 5 May 2014 15:34:29 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Dan Carpenter <dan.carpenter@oracle.com>
cc: hans.verkuil@cisco.com, m.chehab@samsung.com, ext-eero.nurkkala@nokia.com,
        nils.faerber@kernelconcepts.de, joni.lapilainen@gmail.com,
        freemangordon@abv.bg, sre@ring0.de, pali.rohar@gmail.com,
        Greg KH <greg@kroah.com>, linux-media@vger.kernel.org,
        kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] radio-bcm2048.c: fix wrong overflow check
In-Reply-To: <20140422125726.GA30238@mwanda>
Message-ID: <alpine.LNX.2.00.1405051534090.3969@pobox.suse.cz>
References: <20140422125726.GA30238@mwanda>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Apr 2014, Dan Carpenter wrote:

> From: Pali Rohár <pali.rohar@gmail.com>
> 
> This patch fixes an off by one check in bcm2048_set_region().
> 
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
> Signed-off-by: Pavel Machek <pavel@ucw.cz>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> v2: Send it to the correct list.  Re-work the changelog.
> 
> This patch has been floating around for four months but Pavel and Pali
> are knuckle-heads and don't know how to use get_maintainer.pl so they
> never send it to linux-media.
> 
> Also Pali doesn't give reporter credit and Pavel steals authorship
> credit.
> 
> Also when you try explain to them about how to send patches correctly
> they complain that they have been trying but it is too much work so now
> I have to do it.  During the past four months thousands of other people
> have been able to send patches in the correct format to the correct list
> but it is too difficult for Pavel and Pali...  *sigh*.

Seems like it's not in linux-next as of today, so I am taking it now. 
Thanks,

-- 
Jiri Kosina
SUSE Labs
