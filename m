Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751577Ab3GXLzJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 07:55:09 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:23393 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840Ab3GXLzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 07:55:07 -0400
X-AuditID: cbfee61b-b7efe6d000007b11-49-51efc099f184
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: gregkh@linuxfoundation.org, Piotr Sarna <p.sarna@partner.samsung.com>,
        konrad.wilk@oracle.com, bob.liu@oracle.com,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH] zcache: fix "zcache=" kernel parameter
Date: Wed, 24 Jul 2013 13:54:56 +0200
Message-id: <4003586.oV5ROrQ3Ke@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-45-generic; KDE/4.8.5; i686; ; )
In-reply-to: <20130724114157.GB3976@dhcp22.suse.cz>
References: <1374245201-24474-1-git-send-email-p.sarna@partner.samsung.com>
 <7560549.NYTHa4SYx0@amdc1032> <20130724114157.GB3976@dhcp22.suse.cz>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFLMWRmVeSWpSXmKPExsVy+t9jAd2ZB94HGrydo2vRdWoqi8WeM7/Y
	LZoXr2ezWLb4KaPF2aY37BaXd81hs3jV/J3VYtWiKAcOj3v7DrN47J+7ht3j49NbLB4H3+1h
	8ujbsorR48yCI+wenzfJBbBHcdmkpOZklqUW6dslcGVMO3KcveANd0XfhseMDYzzOLsYOTkk
	BEwkZq2dygxhi0lcuLeeDcQWEljEKPH8LVANF5DdwiTRfvMfI0iCTcBKYmL7KjBbREBR4v61
	V4wgRcwC9xglTh9/AtYtLGAtcfzAQ7CpLAKqElc2tbGD2LwCmhKXp61mArFFBVwlzi36wQJi
	cwoYS1w9fYoRYvMkRol7V+oh6gUlfky+B1bDLCAvsW//VFYIW0ti/c7jTBMYBWYhKZuFpGwW
	krIFjMyrGEVTC5ILipPSc430ihNzi0vz0vWS83M3MYJj4Jn0DsZVDRaHGAU4GJV4eAtmvQsU
	Yk0sK67MPcQowcGsJMJrNf99oBBvSmJlVWpRfnxRaU5q8SFGaQ4WJXHeg63WgUIC6Yklqdmp
	qQWpRTBZJg5OqQbGqn7Xf74XLzL+mJy29FzE2YtpPq+dn5/9vqIpb6PCiy2RZW+8F2uKi6xk
	8bcszVfjUv3p/eFgusB79gXXjecxb7v1/O//i402J7vOO+xZf+Hfypj6l2fUPq27dPvD5+UL
	hVcIBbgZmKUu97lxdbbclPdBE7OOPG8XN+cwmJzJcK1+2YStDz88nKfEUpyRaKjFXFScCACa
	ozWNfQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wednesday, July 24, 2013 01:41:57 PM Michal Hocko wrote:
> On Wed 24-07-13 12:32:32, Bartlomiej Zolnierkiewicz wrote:
> > 
> > Hi,
> > 
> > On Wednesday, July 24, 2013 12:04:41 PM Michal Hocko wrote:
> > > On Wed 24-07-13 12:02:35, Michal Hocko wrote:
> > > > I have posted a similar fix quite some time ago and I guess Greg should
> > > > already have it.
> > > 
> > > For reference https://lkml.org/lkml/2013/6/26/410
> > 
> > There was a reply from Greg:
> > 
> > 	https://lkml.org/lkml/2013/6/26/410
> 
> I guess you meant https://lkml.org/lkml/2013/6/26/569

Uh, yes.

> > and it seems that Greg's request has not been fullfilled.
> 
> Bob Liu has resent the patch (I cannot find the email in the archive).

Indeed, I've found it here:

http://comments.gmane.org/gmane.linux.kernel.mm/102484

> > Anyway Piotr's patch seems to be more complete:
> > - it also fixes case in which invalid "zcache=" option is given (returns
> >   an error value 1 while with your patch the code still erronously retuns 0)
> > - it prints information about compressor type being used when "zcache="
> >   option is used (your patch skips it due to addition of "goto out_alloc")
> 
> I do not care which one will make it I just pointed out that there is
> another patch dealing with the same and it is a question how far that
> one went.

OK.

Greg, could you please pick Piotr's patch?

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

