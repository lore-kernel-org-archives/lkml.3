Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752216AbbASSTu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 13:19:50 -0500
Received: from mout.web.de ([212.227.15.4]:52622 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751677AbbASSTs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 13:19:48 -0500
Message-ID: <54BD4AB6.70708@users.sourceforge.net>
Date: Mon, 19 Jan 2015 19:19:34 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Brian Norris <computersforpeace@gmail.com>
CC: David Woodhouse <dwmw2@infradead.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-mtd@lists.infradead.org, LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH] MTD: Deletion of checks before the function call "iounmap"
References: <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net> <54BBE87C.9020705@users.sourceforge.net> <20150119175835.GH9759@ld-irv-0074>
In-Reply-To: <20150119175835.GH9759@ld-irv-0074>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:UayR2WTBOumb+bnlXxukWDGzPzgF8EML+xPFRKZ4IKUMwzXGSxT
 Fc+u0WZqC8vWDILAApkyJkiEKgqdJHYm9VjkkI+LOafY0tUJSP4OFuWamLqzPFIHOcgZx/X
 CFhym9jnB1R6olCZTh8vkSvQHkWIV4oLhiWezG1B//GgLboXR/VAyfAIZ9gEKgkFxOty455
 6nII19NUe0kvciw28Vlxw==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Anyway, I'm essentially saying that I'd like to be 100% sure we have a
> guarantee before dropping all these.

You can not be absolutely sure. There are various implementation details
which will eventually need further considerations.

I hope that a reasonable confidence can be achieved here.


>> This issue was detected by using the Coccinelle software.
> 
> What script?

I published scripts for static source code analysis in March 2004.


> Hand-rolled I guess?

An extended version found some update candidates in source files for Linux
according to the software development status of "next-20141226".

My approach is still incomplete at the moment.

Regards,
Markus
