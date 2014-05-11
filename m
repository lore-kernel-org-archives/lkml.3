Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758152AbaEKVGc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 17:06:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45940 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758022AbaEKVGb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 17:06:31 -0400
Date: Sun, 11 May 2014 23:06:27 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: =?ISO-8859-15?Q?Pali_Roh=E1r?= <pali.rohar@gmail.com>
cc: Dan Carpenter <dan.carpenter@oracle.com>, hans.verkuil@cisco.com,
        m.chehab@samsung.com, ext-eero.nurkkala@nokia.com,
        nils.faerber@kernelconcepts.de, joni.lapilainen@gmail.com,
        freemangordon@abv.bg, sre@ring0.de, Greg KH <greg@kroah.com>,
        linux-media@vger.kernel.org,
        kernel list <linux-kernel@vger.kernel.org>,
        Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH v2] radio-bcm2048.c: fix wrong overflow check
In-Reply-To: <201405091810.18289@pali>
Message-ID: <alpine.LNX.2.00.1405112304510.5813@pobox.suse.cz>
References: <20140422125726.GA30238@mwanda> <alpine.LNX.2.00.1405051534090.3969@pobox.suse.cz> <201405091810.18289@pali>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 May 2014, Pali Rohár wrote:

> > Seems like it's not in linux-next as of today, so I am taking
> > it now. Thanks,
> 
> I still do not see this patch in torvalds branch... So what is 
> needed to include this security buffer overflow patch into 
> mainline & stable kernels?

I picked it up 4 days ago into trivial.git, which is a tree that doesn't 
get pushed to Linus really super-often.

Of course, if, in the meantime, this goes in through maintainer tree, even 
better.

-- 
Jiri Kosina
SUSE Labs
