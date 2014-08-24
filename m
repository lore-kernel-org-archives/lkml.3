Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752634AbaHXMB1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2014 08:01:27 -0400
Received: from purkki.adurom.net ([80.68.90.206]:33120 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752302AbaHXMBZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2014 08:01:25 -0400
From: Kalle Valo <kvalo@adurom.com>
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: net: wireless: Add include guards
References: <1408710414-13810-1-git-send-email-linux@rasmusvillemoes.dk>
Date: Sun, 24 Aug 2014 15:01:22 +0300
In-Reply-To: <1408710414-13810-1-git-send-email-linux@rasmusvillemoes.dk>
	(Rasmus Villemoes's message of "Fri, 22 Aug 2014 14:26:54 +0200")
Message-ID: <87ppfq85bh.fsf@purkki.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rasmus Villemoes <linux@rasmusvillemoes.dk> writes:

> The files ray_cs.h and rayctl.h both contain two thirds of what
> appears to be an include guard using the macro name RAYLINK_H (both
> lack the #define). Since RAYLINK_H is not defined anywhere, the
> guards using different macro names.
>
> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> ---
>  drivers/net/wireless/ray_cs.h | 5 +++--
>  drivers/net/wireless/rayctl.h | 5 +++--

As this a change to ray_cs driver, please use prefix "ray_cs:" and drop
that "drivers: net: wireless:".

-- 
Kalle Valo
