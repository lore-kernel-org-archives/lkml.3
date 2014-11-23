Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751248AbaKWNZE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 08:25:04 -0500
Received: from mout.web.de ([212.227.17.11]:60102 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751014AbaKWNZC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 08:25:02 -0500
Message-ID: <5471E010.2090105@users.sourceforge.net>
Date: Sun, 23 Nov 2014 14:24:32 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Julia Lawall <julia.lawall@lip6.fr>
CC: Dan Carpenter <dan.carpenter@oracle.com>, trivial@kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Eric Paris <eparis@redhat.com>, Coccinelle <cocci@systeme.lip6.fr>
Subject: Re: kernel-audit: Deletion of an unnecessary check before the function
 call "audit_log_end"
References: <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net> <54687F1A.1010809@users.sourceforge.net> <20141116111023.GA4905@mwanda> <20141116111446.GA4956@mwanda> <54688F15.9070703@users.sourceforge.net> <20141117073408.GC4905@mwanda> <5469B836.8030507@users.sourceforge.net> <alpine.DEB.2.02.1411231249310.2261@localhost6.localdomain6>
In-Reply-To: <alpine.DEB.2.02.1411231249310.2261@localhost6.localdomain6>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:aPjMBGAsxFTEmYd/23a4FseKlNeriVb6lvWKl4pEe3AqUL9bpDK
 CePIhJO4MQHAai/FVMpV6LAmvkb7NW39xdZHldlYl74bBYqtHXGVSGBCYMGuFh0pblM59w/
 p4x54V+9aStGDQo2nI2xiNHig0FgKsKYRxoOsn90kRYSUhOK//YVKpc+NtMKsGWwoHox4vH
 QUHkV2rqepcVibdZqsR1g==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Normally, tests only hurt readability if they cannot be false or cannot be true. 
> Making a choice apparent when there really is a choice would seem 
> to aid understanding.

I agree also to such facts.


> Program analysis tools can also potentially exploit this information,

The published semantic patch scripts correspond to this desire.


> which you are so systmatically removing.

I try to delete redundant checks in various function implementations as much
as possible.

Regards,
Markus
