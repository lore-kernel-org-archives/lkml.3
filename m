Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752720AbaKQObQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 09:31:16 -0500
Received: from mout.web.de ([212.227.17.11]:57552 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751886AbaKQObO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 09:31:14 -0500
Message-ID: <546A06A1.3060203@users.sourceforge.net>
Date: Mon, 17 Nov 2014 15:30:57 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Coccinelle <cocci@systeme.lip6.fr>, Eric Paris <eparis@redhat.com>,
        Frank Blaschka <blaschka@linux.vnet.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Ursula Braun <ursula.braun@de.ibm.com>, linux390@de.ibm.com,
        linux-s390@vger.kernel.org
Subject: Re: s390/net: Deletion of unnecessary checks before two function
 calls
References: <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net> <54687F1A.1010809@users.sourceforge.net> <20141116111023.GA4905@mwanda> <20141116111446.GA4956@mwanda> <54688F15.9070703@users.sourceforge.net> <20141117073408.GC4905@mwanda> <5469B836.8030507@users.sourceforge.net> <20141117134515.GE4905@mwanda>
In-Reply-To: <20141117134515.GE4905@mwanda>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:zhqBaAhx3eucUQLURbAnnaQHu54kfwVXBuITAYbzRbXd43cB0et
 nDquFlSMgf5C+cLy3N//tm2CXSUeNcJfSvcrBCioeGrMBHr+MyO9s/NzK7GTHPlwBNNuAE1
 5hg+5RacsjLkQZgOsZMJHAOwW3mKrwvINtS+qPQ5+N0b/byNIMLvw7QVfAYoOYLjUbCmDyj
 BrgKhYegmk0IvoqzbPxWw==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> What do you want me to clarify?  Do you still not see the bug?

Would you like to point out that you notice the warning message
"fsm: kfree_fsm called with NULL argument" after my update suggestion?

How do you think about to share a bit more information about the
corresponding function call graph from your test system?

Regards,
Markus

