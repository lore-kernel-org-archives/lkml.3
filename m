Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932333AbaLATR4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 14:17:56 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:40119 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753822AbaLATRy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 14:17:54 -0500
Date: Mon, 1 Dec 2014 22:17:23 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        Julia Lawall <julia.lawall@lip6.fr>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, trivial@kernel.org,
        Coccinelle <cocci@systeme.lip6.fr>
Subject: Re: [PATCH v2] fs-fat: Less function calls in fat_fill_super() after
 error detection
Message-ID: <20141201191723.GG4994@mwanda>
References: <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>
 <5317A59D.4@users.sourceforge.net>
 <5467B12C.4010602@users.sourceforge.net>
 <alpine.DEB.2.02.1411152117540.2225@localhost6.localdomain6>
 <54796B5E.5040707@users.sourceforge.net>
 <87sih22sn8.fsf@devron.myhome.or.jp>
 <alpine.DEB.2.10.1411291338530.2378@hadrien>
 <87lhmu2jl8.fsf@devron.myhome.or.jp>
 <20141201065221.GA4994@mwanda>
 <547C89A4.40002@users.sourceforge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <547C89A4.40002@users.sourceforge.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 01, 2014 at 04:30:44PM +0100, SF Markus Elfring wrote:
> > Meanwhile Markus's error labels are absolutely useless.  They give no
> > indication of what going to the label does.
> 
> Which names would be better acceptable for you?

You named it after the goto location but the label name should be based
on the label location to say what the goto does.  Something like
"err_put_fsinfo", "err_put_fat", and "err_unload" or like that.

regards,
dan carpenter

