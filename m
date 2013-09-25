Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755019Ab3IYT1k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 15:27:40 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:45556 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754980Ab3IYT1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 15:27:39 -0400
Message-ID: <5243390C.8030509@tilera.com>
Date: Wed, 25 Sep 2013 15:27:08 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Henrik Austad <haustad@cisco.com>
CC: Henrik Austad <henrik@austad.us>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tile: change lock initalization in hardwall
References: <1380118600-30352-1-git-send-email-haustad@cisco.com>
In-Reply-To: <1380118600-30352-1-git-send-email-haustad@cisco.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/25/2013 10:16 AM, Henrik Austad wrote:
> hardwall used __SPIN_LOCK_INITIALIZER directly instead of the preferred
> __SPIN_LOCK_UNLOCKED. This also has the benefit that it will compile
> when applying the preempt-rt patch series.
>
> Signed-off-by: Henrik Austad <haustad@cisco.com>
> ---
>  arch/tile/kernel/hardwall.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

Thanks!  Taken into the tile tree for 3.12.

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

