Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751531AbaF1JIy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 05:08:54 -0400
Received: from mout.web.de ([212.227.17.12]:55695 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750720AbaF1JIw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 05:08:52 -0400
Message-ID: <53AE8613.8080600@users.sourceforge.net>
Date: Sat, 28 Jun 2014 11:08:35 +0200
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Fabian Frederick <fabf@skynet.be>
CC: linux-kernel@vger.kernel.org, Coccinelle <cocci@systeme.lip6.fr>,
        Joe Perches <joe@perches.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH V3] scripts/coccinelle/free: Delete NULL test before freeing
 functions?
References: <1403945247-21549-1-git-send-email-fabf@skynet.be>
In-Reply-To: <1403945247-21549-1-git-send-email-fabf@skynet.be>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:VtlDQQgIwc/hxXrJ4jWFIQpricVBYbe0xzMq6J1fDwivNgtvgSK
 wiLrK6BmMdKZlX9xW/sAN631LVsWuxfkQotfxdCjrqomI9WWV4ercWZ/VUKXKYSSOKAN9K0
 Nu/ae8/etFBNcDqBf7LcSliXAYdnsG7LvkYw6bGnOREOf0m0+zUEvYtbSOBVXRVLQhoQSPv
 ulA2J7GVaIG81HCI2pIiA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> V3: 
>    -Update print_main message.

Does the discussion topic need also an adjustment?

How do you think about my previous update suggestion "Deletion of
unnecessary checks before specific function calls"?
https://systeme.lip6.fr/pipermail/cocci/2014-March/000675.html
https://lkml.org/lkml/2014/3/5/344

Regards,
Markus
