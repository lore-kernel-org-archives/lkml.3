Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753453Ab3BCDud (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 22:50:33 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:48255 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752925Ab3BCDub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 22:50:31 -0500
Date: Sat, 2 Feb 2013 19:46:34 -0800
From: Anton Vorontsov <anton@enomsg.org>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        rusty@rustcorp.com.au, bfields@fieldses.org, skinsbursky@parallels.com,
        ebiederm@xmission.com, jmorris@namei.org, axboe@kernel.dk,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 40/62] power: convert to idr_alloc()
Message-ID: <20130203034634.GI25016@lizard.sbx00618.mountca.wayport.net>
References: <1359854463-2538-1-git-send-email-tj@kernel.org>
 <1359854463-2538-41-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1359854463-2538-41-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 02, 2013 at 05:20:41PM -0800, Tejun Heo wrote:
> Convert to the much saner new idr interface.
> 
> Only compile tested.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Anton Vorontsov <cbou@mail.ru>
> Cc: David Woodhouse <dwmw2@infradead.org>
> ---
> This patch depends on an earlier idr changes and I think it would be
> best to route these together through -mm.  Please holler if there's
> any objection.  Thanks.

Sure thing, Ack for these:

>  drivers/power/bq2415x_charger.c | 11 +++--------
>  drivers/power/bq27x00_battery.c |  9 +++------
>  drivers/power/ds2782_battery.c  |  9 ++-------
>  3 files changed, 8 insertions(+), 21 deletions(-)

Thanks!

Anton
