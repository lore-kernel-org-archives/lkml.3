Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932100AbaLAPbI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 10:31:08 -0500
Received: from mout.web.de ([212.227.15.3]:60235 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753102AbaLAPbF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 10:31:05 -0500
Message-ID: <547C89A4.40002@users.sourceforge.net>
Date: Mon, 01 Dec 2014 16:30:44 +0100
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
References: <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net> <5467B12C.4010602@users.sourceforge.net> <alpine.DEB.2.02.1411152117540.2225@localhost6.localdomain6> <54796B5E.5040707@users.sourceforge.net> <87sih22sn8.fsf@devron.myhome.or.jp> <alpine.DEB.2.10.1411291338530.2378@hadrien> <87lhmu2jl8.fsf@devron.myhome.or.jp> <20141201065221.GA4994@mwanda>
In-Reply-To: <20141201065221.GA4994@mwanda>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:YxclwA7pwhEL7fXbOm3vU7stqpG7mkRLJTEOkMsPg75RC62pCR/
 aOJKK6Ax9RTfTqsEfl7RK0D5eoWNeP6UqeSv+hTS/KCwMU+5w82H5ViZlyxMHgkafF+ApUl
 +laSMlOfNRW+7YYipKNAxbf129zEZHavh4vRZi4NSDISdZC4xkpprGKASnmv27aIuISZXAn
 bztFgxYjLWbkXgncmvjJg==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Mixing the error paths together it always creates confusion.
> I fix so many of these bugs...  We get a few new ones every week.

Would you like to get help here from any other automatic semantic
patch approaches?


> Meanwhile Markus's error labels are absolutely useless.  They give no
> indication of what going to the label does.

Which names would be better acceptable for you?

Regards,
Markus
