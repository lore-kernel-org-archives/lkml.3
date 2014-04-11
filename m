Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755094AbaDKGPQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 02:15:16 -0400
Received: from mout.web.de ([212.227.15.3]:57007 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752192AbaDKGPO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 02:15:14 -0400
Message-ID: <5347886F.8070307@users.sourceforge.net>
Date: Fri, 11 Apr 2014 08:15:11 +0200
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Julia Lawall <julia.lawall@lip6.fr>
CC: "Luis R. Rodriguez" <mcgrof@suse.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org, backports@vger.kernel.org,
        cocci@systeme.lip6.fr
Subject: Re: [Cocci] [PATCH] coccinelle: add pycocci wrapper for multithreaded
 support
References: <1397152097-315-1-git-send-email-mcgrof@do-not-panic.com> <1397152289.4757.28.camel@jlt4.sipsolutions.net> <20140410175748.GK14815@wotan.suse.de> <534783DB.4080200@users.sourceforge.net> <alpine.DEB.2.02.1404110800120.2032@localhost6.localdomain6>
In-Reply-To: <alpine.DEB.2.02.1404110800120.2032@localhost6.localdomain6>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:2CosSyxhwBesuAs26UmEtbgyV9zXGWVyEtwwXObThkA8XDDmdrq
 z/DHBpc8EPnZkIdWzLpDp6HpAW1pHr1V4WP409dxQjROyaC76yX2uOZYzQ/n3GdOf4APaxQ
 +zDqvRBpNmA9OALB0SYdwzI05iWV1I5sz/ipirienYtEeUfS7xGAomfghfYvutIdQu7cMJV
 XkUEJ3xlCWlWVE3lHo/Lw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Could you find out during the data processing which parts or files
>> result in a special application behaviour you would like to point out here?
> I don't understand the question at all, but since the various files have 
> different properties, it is hard to determine automatically in advance how 
> much work Coccinelle will need to do on each one.

It was reported that a system utilisation did not fit to some
expectations. I am curious if any more details or patterns can be
determined for an observed situation.

Do the involved files need also another look?
- semantic patches
- source directories

Regards,
Markus
