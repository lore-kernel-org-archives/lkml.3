Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933019AbaKSU5V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 15:57:21 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40776 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932470AbaKSU5S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 15:57:18 -0500
Date: Wed, 19 Nov 2014 21:57:16 +0100
From: Jan Kara <jack@suse.cz>
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org, Coccinelle <cocci@systeme.lip6.fr>
Subject: Re: [PATCH 0/2] fs-udf: Deletion of two unnecessary checks
Message-ID: <20141119205716.GA16592@quack.suse.cz>
References: <530C5E18.1020800@users.sourceforge.net>
 <alpine.DEB.2.10.1402251014170.2080@hadrien>
 <530CD2C4.4050903@users.sourceforge.net>
 <alpine.DEB.2.10.1402251840450.7035@hadrien>
 <530CF8FF.8080600@users.sourceforge.net>
 <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6>
 <530DD06F.4090703@users.sourceforge.net>
 <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>
 <5317A59D.4@users.sourceforge.net>
 <546B8814.2030701@users.sourceforge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <546B8814.2030701@users.sourceforge.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 18-11-14 18:55:32, SF Markus Elfring wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Tue, 18 Nov 2014 18:33:08 +0100
> 
> Another update suggestion was taken into account after a patch was applied
> from static source code analysis.
  I've merged both patches. Thanks.

								Honza
> 
> Markus Elfring (2):
>   Deletion of unnecessary checks before the function call "iput"
>   One function call less in udf_fill_super() after error detection
> 
>  fs/udf/super.c | 11 +++++------
>  1 file changed, 5 insertions(+), 6 deletions(-)
> 
> -- 
> 2.1.3
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
