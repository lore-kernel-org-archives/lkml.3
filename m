Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751763AbaF1VAh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 17:00:37 -0400
Received: from mout.web.de ([212.227.15.4]:61097 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751243AbaF1VAg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 17:00:36 -0400
Message-ID: <53AF2CE6.5020300@users.sourceforge.net>
Date: Sat, 28 Jun 2014 23:00:22 +0200
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Fabian Frederick <fabf@skynet.be>
CC: linux-kernel@vger.kernel.org, Coccinelle <cocci@systeme.lip6.fr>,
        Joe Perches <joe@perches.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH V3] scripts/coccinelle/free: Delete NULL test before freeing
 functions?
References: <1403945247-21549-1-git-send-email-fabf@skynet.be>	<53AE8613.8080600@users.sourceforge.net>	<20140628120052.0b8670723928a967808dd544@skynet.be>	<53AEA927.3010100@users.sourceforge.net> <20140628140157.98304218ad0919b1567cfee4@skynet.be>
In-Reply-To: <20140628140157.98304218ad0919b1567cfee4@skynet.be>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:Qlpc0rZQZmMQ6tHTSpPIfSIa17OyiMfCfURKTeX7GVLMPBbUyQ1
 0/Wn2oXvhHc1VCxtt28uj2PUiKJtX1iVzw/8s6MDiCnfX7g4wyDJOGs8QfofYvENoDYuHkr
 GxNrQjeIcsBVJjatNo2vybB0SOZuwn8cJLon8vkuOicbfomagfHFasjSlp6V34HcEF466Yo
 AZzoXSAjXVm2YaFquE9JA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Sorry but I'm not working on coccinelle ; just did a small script for kernel tree.

I would appreciate a more constructive feedback for my update suggestions around
the topic "Deletion of unnecessary checks before specific function calls".
- Did you look at the concrete patches?
- How do you think about the general approach?

Examples:
https://systeme.lip6.fr/pipermail/cocci/2014-March/000676.html
http://marc.info/?l=kernel-janitors&m=139405971927100&w=2

https://systeme.lip6.fr/pipermail/cocci/2014-March/000677.html
http://marc.info/?l=kernel-janitors&m=139405983727148&w=2

Regards,
Markus
