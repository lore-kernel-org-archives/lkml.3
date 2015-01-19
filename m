Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751887AbbASTHn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 14:07:43 -0500
Received: from mout.web.de ([212.227.17.12]:63723 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751520AbbASTHm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 14:07:42 -0500
Message-ID: <54BD55F6.6090609@users.sourceforge.net>
Date: Mon, 19 Jan 2015 20:07:34 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Brian Norris <computersforpeace@gmail.com>
CC: David Woodhouse <dwmw2@infradead.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-mtd@lists.infradead.org, LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH] MTD: Deletion of checks before the function call "iounmap"
References: <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net> <54BBE87C.9020705@users.sourceforge.net> <20150119175835.GH9759@ld-irv-0074> <54BD4AB6.70708@users.sourceforge.net> <20150119183057.GI9759@ld-irv-0074>
In-Reply-To: <20150119183057.GI9759@ld-irv-0074>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:NJ1NuUw7D3m3XXc+EOFNkEridfHaEe2Hs6uD3eVMU3zTZlN8VtK
 IsBMEn2Nr0d5Y5ixqNbCSTpMizQMdxR2KMM042CqdEZmOLR9LH9YdVdM/k4EuqOuu2wrq3X
 eAlYT8lQr5mykdMY4yYNL1N/30eGTwmk61kXKeAYqTxMlNwdouXKHuP73mBuYfTIB7pEJTQ
 /bmwOdtET+KrwW6me+hdQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> I published scripts for static source code analysis in March 2004.
> 
> I didn't ask "when?"; where?

https://lkml.org/lkml/2014/3/5/356
http://article.gmane.org/gmane.comp.version-control.coccinelle/3513/
https://systeme.lip6.fr/pipermail/cocci/2014-March/000676.html

Do you get further ideas from this software analysis approach?

Regards,
Markus
