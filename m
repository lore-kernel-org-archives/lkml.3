Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751909AbaKQI4t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 03:56:49 -0500
Received: from mout.web.de ([212.227.17.12]:63264 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751852AbaKQI4r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 03:56:47 -0500
Message-ID: <5469B836.8030507@users.sourceforge.net>
Date: Mon, 17 Nov 2014 09:56:22 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, trivial@kernel.org,
        Coccinelle <cocci@systeme.lip6.fr>
Subject: Re: [PATCH 1/1] kernel-audit: Deletion of an unnecessary check before
 the function call "audit_log_end"
References: <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net> <54687F1A.1010809@users.sourceforge.net> <20141116111023.GA4905@mwanda> <20141116111446.GA4956@mwanda> <54688F15.9070703@users.sourceforge.net> <20141117073408.GC4905@mwanda>
In-Reply-To: <20141117073408.GC4905@mwanda>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:bUCDTBJ6bDInqFWcw5OQ8MbVsnAu0MDPBH7ASgNAIeRq6hakJxp
 HgjSeVAYPF7iK3e05qW14KZBmQ+eDoQ3NmQjPaaU02cE7VIWYJmSVQ6lNXsl4hEe6IZ/4wJ
 8nWjF31fCkXJCE770CfnibJJOpdir9kEbD5y91xKn5WeQa9vyZRzyzHot4Fi/fZhR1/OEgf
 c+G9guJTlp8nRSm9P1Zkw==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> You removed the statement from "if (foo) kfree_fsm(foo);" so now it
> prints a warning.
> 
> drivers/s390/net/fsm.c

Would it be better to continue the clarification of affected implementation details
under the discussion topic "s390/net: Deletion of unnecessary checks before two function calls"?


>> It is an usual software development challenge to decide on the best source code places
>> where to put input parameter validation (and when it can be omitted), isn't it?
> 
> No, it's not.  You should just try to write the most readable software
> you can instead of removing if statements because you can.

Additional safety checks have also got an effect on source code readability, haven't they?

Regards,
Markus
