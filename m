Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753229AbbAVQaO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 11:30:14 -0500
Received: from mout.web.de ([212.227.15.3]:60392 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751299AbbAVQaM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 11:30:12 -0500
Message-ID: <54C1254A.4090106@users.sourceforge.net>
Date: Thu, 22 Jan 2015 17:28:58 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Brian Norris <computersforpeace@gmail.com>
CC: David Woodhouse <dwmw2@infradead.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH] MTD: Deletion of checks before the function call "iounmap"
References: <530CF8FF.8080600@users.sourceforge.net>	<alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6>	<530DD06F.4090703@users.sourceforge.net>	<alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>	<5317A59D.4@users.sourceforge.net>	<54BBE87C.9020705@users.sourceforge.net>	<20150119175835.GH9759@ld-irv-0074>	<54BD4AB6.70708@users.sourceforge.net>	<20150119183057.GI9759@ld-irv-0074>	<54BD55F6.6090609@users.sourceforge.net>	<20150119203143.GL9759@ld-irv-0074>	<54BD7E7D.9060107@users.sourceforge.net> <CAN8TOE9_cHJ+kbWGkaqHujLSWLLAAgXyumG5s9tWYoyrFk-=uQ@mail.gmail.com>
In-Reply-To: <CAN8TOE9_cHJ+kbWGkaqHujLSWLLAAgXyumG5s9tWYoyrFk-=uQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:+e4e6WhbV7u5zHC+IO3caEw/JXhjJV7N8a2OH0G+AjgFZV6bZDn
 VX8+JPP0VZ36dhQ1gQJT0+mUJd2Q73uzgbEooxOe2edMunez7nr/iC+Nr8RyYMlb0yKcndu
 /nxKo4tAx6XtReO6oWXRrbtBzmav9XtJQvbPw09cLk+85ROZVA4spRO3Cs4jIO0xSvwuEKU
 Y4/0Gb/voMZQrnKkJ+E3Q==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The only evidence I see is a long thread of similar patches from
> the last several months, of varying (though not increasing) quality.

I find it acceptable that some of my update suggestions do not fit
to your quality expectations at the moment.


> Prior objections to your approach were met with a distinct lack
> of self-awareness on your part.

I guess that a bit more clarification of this view will help
to resolve some open issues, won't it?


> I don't really see many challenges here to tackle, except for the
> social issue of dealing with patch bots like you.

I hope that you will like other automatic source code analysis results.


> Your automated patches are generally not solving real problems,

I try to clean-up Linux source files a bit. Problem solving
with a higher value might follow ...


> but they are at times introducing bugs.

There are the usual different opinions and disagreements
which might be still waiting for a constructive solution.

Regards,
Markus
