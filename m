Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755960AbaFYVLx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 17:11:53 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755560AbaFYVLw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 17:11:52 -0400
Message-ID: <53AB3B12.5000605@nod.at>
Date: Wed, 25 Jun 2014 23:11:46 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Heiko Schocher <hs@denx.de>, linux-mtd@lists.infradead.org
CC: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Mike Snitzer <snitzer@redhat.com>, Wolfgang Denk <wd@denx.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ubi: fix correct rb_tree node comparison in add_vol
References: <1403594718-20595-1-git-send-email-hs@denx.de>
In-Reply-To: <1403594718-20595-1-git-send-email-hs@denx.de>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 24.06.2014 09:25, schrieb Heiko Schocher:
> Commit 604b592e6fd3c98f21435e1181ba7723ffc24715 ("UBI: fix rb_tree node comparison in add_map")
> 
> introduced problems with attaching ubi fastmap images,
> created with older kernel.
> 
> As in ubi_find_av() from attach.c is
> [...]
>                 if (vol_id > av->vol_id)
>                         p = p->rb_left;
>                 else
>                         p = p->rb_right;
> 
> sync this logic also in add_vol() with this.
> 
> With this patch attaching older ubi images works again.
> 
> Signed-off-by: Heiko Schocher <hs@denx.de>

Thanks a lot for fixing this!

Acked-by: Richard Weinberger <richard@nod.at>

Thanks,
//richard
