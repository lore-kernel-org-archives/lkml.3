Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752462AbaCUX5W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 19:57:22 -0400
Received: from b.ns.miles-group.at ([95.130.255.144]:1660 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751002AbaCUX5V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 19:57:21 -0400
Message-ID: <532CD1CB.4070707@nod.at>
Date: Sat, 22 Mar 2014 00:56:59 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Mike Snitzer <snitzer@redhat.com>
CC: linux-kernel@vger.kernel.org, Artem Bityutskiy <dedekind1@gmail.com>,
        linux-mtd@lists.infradead.org
Subject: Re: [RFC PATCH] UBI: fix rb_tree node comparison in add_map
References: <20140321195403.GA32529@redhat.com>
In-Reply-To: <20140321195403.GA32529@redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 21.03.2014 20:54, schrieb Mike Snitzer:
> The comparisons used in add_vol() shouldn't be identical.  Pretty sure
> the following is correct but it is completely untested.
> 
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> ---
>  drivers/mtd/ubi/fastmap.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> NOTE: I stumbled upon this code while implementing some rb_tree code
>       (and looking for some existing rb_tree code as a reference).

Thanks a lot for pointing this out!

Acked-by: Richard Weinberger <richard@nod.at>

Thanks,
//richard
