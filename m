Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752885AbaF2Kpv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2014 06:45:51 -0400
Received: from mout.web.de ([212.227.15.14]:64886 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752718AbaF2Kpu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2014 06:45:50 -0400
Message-ID: <53AFEE55.7080906@users.sourceforge.net>
Date: Sun, 29 Jun 2014 12:45:41 +0200
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Julia Lawall <julia.lawall@lip6.fr>
CC: Coccinelle <cocci@systeme.lip6.fr>, linux-kernel@vger.kernel.org,
        Fabian Frederick <fabf@skynet.be>
Subject: Re: [Cocci] [PATCH V3] scripts/coccinelle/free: Delete NULL test
 before freeing functions?
References: <1403945247-21549-1-git-send-email-fabf@skynet.be> <53AE8613.8080600@users.sourceforge.net> <20140628120052.0b8670723928a967808dd544@skynet.be> <53AEA927.3010100@users.sourceforge.net> <20140628140157.98304218ad0919b1567cfee4@skynet.be> <53AF2CE6.5020300@users.sourceforge.net> <alpine.DEB.2.02.1406282326010.2022@localhost6.localdomain6>
In-Reply-To: <alpine.DEB.2.02.1406282326010.2022@localhost6.localdomain6>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:LtTuMBEB3Z3/eVcj2JfTP1FMFKLcHIbhk60w527qNSeG1fPRkfu
 m+DlOU+tGD5Uz28103YUa8C1QN+dUxSyXMV2ruH6SHjPUlN9XhhYTyJdnLf+WisYGl25YlZ
 QILBq8kJMDiBj/q5AjhvpNNazBq1HFtV47YyRix8wPFk9N8Ii91Lzgzqzuob97JozdtpI/L
 GRacX97QlH1ooIllddlFQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> https://systeme.lip6.fr/pipermail/cocci/2014-March/000676.html
>> http://marc.info/?l=kernel-janitors&m=139405971927100&w=2
> Regular expressions do not allow taking advantage of the optimizations 
> provided by Coccinelle and are not easy for a reader to understand.

I find that the application of regexes is appropriate here.
Would you like to optimise any implementation details from my general
approach?


>> https://systeme.lip6.fr/pipermail/cocci/2014-March/000677.html
>> http://marc.info/?l=kernel-janitors&m=139405983727148&w=2
> This is not safe due to the use of when any.  You have no guarantee that 
> there is not a dereference of input in the matched region, or that the 
> value of input is still the argument value at the point of the test.

Do you suggest to make the desired detection of input parameter
validation a bit safer?

Regards,
Markus
