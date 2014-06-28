Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752646AbaF1LiV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 07:38:21 -0400
Received: from mout.web.de ([212.227.17.11]:51395 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751668AbaF1LiU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 07:38:20 -0400
Message-ID: <53AEA927.3010100@users.sourceforge.net>
Date: Sat, 28 Jun 2014 13:38:15 +0200
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Fabian Frederick <fabf@skynet.be>
CC: linux-kernel@vger.kernel.org, Coccinelle <cocci@systeme.lip6.fr>,
        Joe Perches <joe@perches.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH V3] scripts/coccinelle/free: Delete NULL test before freeing
 functions?
References: <1403945247-21549-1-git-send-email-fabf@skynet.be>	<53AE8613.8080600@users.sourceforge.net> <20140628120052.0b8670723928a967808dd544@skynet.be>
In-Reply-To: <20140628120052.0b8670723928a967808dd544@skynet.be>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:0cz22nfCTQi/jSJLXr9Uso5Qk1T8bhnKs2Cv6NkI1WnL+f3mypf
 KIzPnBirASP1S93f8ak8zrcHKRKfgWe2rvJL5aXJ9d0e7kil/L5XOijJXcI5dqr/BprRBWM
 2dyvTZwrJ8H9+F/yo4JJiwO6vrHPATg6x84eaHzKiUcfmVAlUxPhlhs++wYWOqZh5HBFE+s
 jVWN/KdKPkRpVKoH6J6mQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> How do you think about my previous update suggestion "Deletion of
>> unnecessary checks before specific function calls"?
>> https://systeme.lip6.fr/pipermail/cocci/2014-March/000675.html
>> https://lkml.org/lkml/2014/3/5/344
>     I didn't see you made the same kind of script.

Will my approach become a bit more complete in the near future?
http://article.gmane.org/gmane.comp.version-control.coccinelle/3512/

Regards,
Markus
