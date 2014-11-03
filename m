Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753267AbaKCRlD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 12:41:03 -0500
Received: from mout.web.de ([212.227.15.4]:54596 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752340AbaKCRk6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 12:40:58 -0500
Message-ID: <5457BE20.5020205@users.sourceforge.net>
Date: Mon, 03 Nov 2014 18:40:48 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Ursula Braun <ursula.braun@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Frank Blaschka <blaschka@linux.vnet.ibm.com>, linux390@de.ibm.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, trivial@kernel.org,
        Coccinelle <cocci@systeme.lip6.fr>
Subject: Re: s390/net: Deletion of unnecessary checks before two function
 calls
References: <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net> <5453C98C.90105@users.sourceforge.net> <20141103095059.GL6879@mwanda> <5457A560.2020304@users.sourceforge.net> <20141103162528.GT6890@mwanda> <5457B268.3020202@users.sourceforge.net> <20141103171625.GU6890@mwanda>
In-Reply-To: <20141103171625.GU6890@mwanda>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:PChmllc3jqsQ5xQDqJaZMh5tJsWyxplzrhPTzFFAAmuwJN0Ys32
 69dlxmKKludFddn3G+n9yEKVTTnZGfZl7TcbEQiObavD2lWrBgNPuyQ59JNv77UexYDCV0N
 qFCBKCLk595Iz3T4rp8haa8STuT/fux5CSuxgDi8T1zfJh+IXcdBv0/xOqHEETztiPlLeOd
 QGsPqtPPZ0wQANGa5XTlA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> If you can benchmark the code and the new code is faster then, yes, this
> patch is good and we will apply it.

I guess that I do not have enough resources myself to measure different run time
effects in a S390 environment.


> If you have no benchmarks then do not send the patch.

Are other software developers and testers eventually interested to try a few
pointer check adjustments out a bit more?

Regards,
Markus
