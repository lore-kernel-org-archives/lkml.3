Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751724Ab3GXLmE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 07:42:04 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53005 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751029Ab3GXLmD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 07:42:03 -0400
Date: Wed, 24 Jul 2013 13:41:57 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: gregkh@linuxfoundation.org, Piotr Sarna <p.sarna@partner.samsung.com>,
        konrad.wilk@oracle.com, bob.liu@oracle.com,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: Re: [PATCH] zcache: fix "zcache=" kernel parameter
Message-ID: <20130724114157.GB3976@dhcp22.suse.cz>
References: <1374245201-24474-1-git-send-email-p.sarna@partner.samsung.com>
 <20130724100235.GC2540@dhcp22.suse.cz>
 <20130724100441.GA3976@dhcp22.suse.cz>
 <7560549.NYTHa4SYx0@amdc1032>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7560549.NYTHa4SYx0@amdc1032>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 24-07-13 12:32:32, Bartlomiej Zolnierkiewicz wrote:
> 
> Hi,
> 
> On Wednesday, July 24, 2013 12:04:41 PM Michal Hocko wrote:
> > On Wed 24-07-13 12:02:35, Michal Hocko wrote:
> > > I have posted a similar fix quite some time ago and I guess Greg should
> > > already have it.
> > 
> > For reference https://lkml.org/lkml/2013/6/26/410
> 
> There was a reply from Greg:
> 
> 	https://lkml.org/lkml/2013/6/26/410

I guess you meant https://lkml.org/lkml/2013/6/26/569

> and it seems that Greg's request has not been fullfilled.

Bob Liu has resent the patch (I cannot find the email in the archive).

> Anyway Piotr's patch seems to be more complete:
> - it also fixes case in which invalid "zcache=" option is given (returns
>   an error value 1 while with your patch the code still erronously retuns 0)
> - it prints information about compressor type being used when "zcache="
>   option is used (your patch skips it due to addition of "goto out_alloc")

I do not care which one will make it I just pointed out that there is
another patch dealing with the same and it is a question how far that
one went.
-- 
Michal Hocko
SUSE Labs
