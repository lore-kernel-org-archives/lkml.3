Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422736AbaD3ReN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 13:34:13 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:42254 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422698AbaD3ReM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 13:34:12 -0400
Date: Wed, 30 Apr 2014 13:34:10 -0400 (EDT)
Message-Id: <20140430.133410.981284387859397046.davem@davemloft.net>
To: kys@microsoft.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com, stable@kernel.org
Subject: Re: [PATCH V2 net-next 1/1] hyperv: Properly handle checksum
 offload
From: David Miller <davem@davemloft.net>
In-Reply-To: <1398873921-20955-1-git-send-email-kys@microsoft.com>
References: <1398873921-20955-1-git-send-email-kys@microsoft.com>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 30 Apr 2014 10:34:12 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "K. Y. Srinivasan" <kys@microsoft.com>
Date: Wed, 30 Apr 2014 09:05:21 -0700

> Do checksum offload only if the client of the driver wants checksum to be
> offloaded.
> 
> In V1 version of this patch, I  addressed comments from
> Stephen Hemminger <stephen@networkplumber.org> and
> Eric Dumazet <eric.dumazet@gmail.com>.
> 
> In this version of the patch I have addressed comments from
> David Miller.
> 
> This patch fixes a bug that is exposed in gateway scenarios.
> 
> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>

It does not make any sense to submit a patch for net-next and
also ask for it to be included in -stable.

First of all, -stable submissions are handled by me directly for
networking.  Therefore you should not CC: stable on such patches,
instead you ask me politly to include it in my stable submission
queue.

Second of all, if a patch is destined for stable, it should be
submitted for 'net' not 'net-next'.
