Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932551AbaLAVXI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 16:23:08 -0500
Received: from mout.web.de ([212.227.17.12]:64887 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932080AbaLAVXF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 16:23:05 -0500
Message-ID: <547CDC1E.7020404@users.sourceforge.net>
Date: Mon, 01 Dec 2014 22:22:38 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        Julia Lawall <julia.lawall@lip6.fr>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, trivial@kernel.org,
        Coccinelle <cocci@systeme.lip6.fr>
Subject: Re: [PATCH v2] fs-fat: Less function calls in fat_fill_super() after
 error detection
References: <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net> <5467B12C.4010602@users.sourceforge.net> <alpine.DEB.2.02.1411152117540.2225@localhost6.localdomain6> <54796B5E.5040707@users.sourceforge.net> <87sih22sn8.fsf@devron.myhome.or.jp> <alpine.DEB.2.10.1411291338530.2378@hadrien> <87lhmu2jl8.fsf@devron.myhome.or.jp> <20141201065221.GA4994@mwanda> <547C89A4.40002@users.sourceforge.net> <20141201191723.GG4994@mwanda>
In-Reply-To: <20141201191723.GG4994@mwanda>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:BugOfKqyRDNORrpHyrVdovi+EYPyhxRTLwLz6Xwh8j5IliwNCyI
 Pk0gbaIbmtFF1SIktIrNToyTBsJPuccr0n1olKsFE7wSOAC3glvdjCFJnZZ8MipFBsdnwsy
 Srxyt0s2aXSGBmur4cGRPtOqc5hwDCpxSRsWFvuHrsZQtBOXq7IDfczcuRL8EU736BpYfs8
 qUr466mr/X0qp3fKQ2zdg==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Which names would be better acceptable for you?
> 
> You named it after the goto location but the label name should be based
> on the label location to say what the goto does.

I find it easier occasionally to name a label similarly to the jump target.
It seems that there are a few variations used for the affected identifiers.


> Something like "err_put_fsinfo", "err_put_fat", and "err_unload" or like that.

How do you think about to provide a patch with your preferred names
if my chances are lower to suggest the pleasing ones directly in my
first tries?

Regards,
Markus
