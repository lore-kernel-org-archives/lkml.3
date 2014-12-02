Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754481AbaLBHfE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 02:35:04 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:38518 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752939AbaLBHfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 02:35:03 -0500
Date: Tue, 2 Dec 2014 10:34:41 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        Julia Lawall <julia.lawall@lip6.fr>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, trivial@kernel.org,
        Coccinelle <cocci@systeme.lip6.fr>
Subject: Re: [PATCH v2] fs-fat: Less function calls in fat_fill_super() after
 error detection
Message-ID: <20141202073440.GH4994@mwanda>
References: <5467B12C.4010602@users.sourceforge.net>
 <alpine.DEB.2.02.1411152117540.2225@localhost6.localdomain6>
 <54796B5E.5040707@users.sourceforge.net>
 <87sih22sn8.fsf@devron.myhome.or.jp>
 <alpine.DEB.2.10.1411291338530.2378@hadrien>
 <87lhmu2jl8.fsf@devron.myhome.or.jp>
 <20141201065221.GA4994@mwanda>
 <547C89A4.40002@users.sourceforge.net>
 <20141201191723.GG4994@mwanda>
 <547CDC1E.7020404@users.sourceforge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <547CDC1E.7020404@users.sourceforge.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 01, 2014 at 10:22:38PM +0100, SF Markus Elfring wrote:
> >> Which names would be better acceptable for you?
> > 
> > You named it after the goto location but the label name should be based
> > on the label location to say what the goto does.
> 
> I find it easier occasionally to name a label similarly to the jump target.

That is a useless thing to do.

> It seems that there are a few variations used for the affected identifiers.

There is a lot of crap code in the kernel, yes.

regards,
dan carpenter

