Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751366AbaHIIXK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2014 04:23:10 -0400
Received: from mout.web.de ([212.227.17.12]:63101 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751212AbaHIIXH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2014 04:23:07 -0400
Message-ID: <53E5DA60.90902@users.sourceforge.net>
Date: Sat, 09 Aug 2014 10:22:56 +0200
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
        Coccinelle <cocci@systeme.lip6.fr>
CC: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Fabian Frederick <fabf@skynet.be>, Joe Perches <joe@perches.com>
Subject: Re: [patch 119/197] scripts/coccinelle/free: Delete NULL test before
 freeing functions
References: <53e53fd1.zO3IbUqJ421c7VXf%akpm@linux-foundation.org>
In-Reply-To: <53e53fd1.zO3IbUqJ421c7VXf%akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:yBB+MAGERiz+ouhu+TNOdjUri31NSLAFkQ43udRV6AKQ8hAxO3m
 fk5GC/+p0dOI9dWMSQhUxhmRY9lQjnIgQHohi8zu/Kk6K6LNrMOdUKIVNL+Mu/KK4nVIxhM
 fweV/bcnDIf8NM/QkqnHH14c5LSJ1VpANiIBOYytFkPM2qMHThDDwQ/pEk/lLQKBdkxo39j
 XBuAdkH0h4SfCTrrfh51w==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +@r depends on context || report || org @
> +expression E;
> +position p;
> +@@
> +
> +* if (E)
> +*	\(kfree@p\|debugfs_remove@p\|debugfs_remove_recursive@p\|usb_free_urb\)(E);

How do you think about to add the construct "@p" also behind the function name
"usb_free_urb"?


Is my previous update suggestion for such an issue worth for another look, too?

Regards,
Markus
