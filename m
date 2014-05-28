Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755241AbaE1TvO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 15:51:14 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:17623 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353AbaE1TvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 15:51:12 -0400
X-CheckPoint: {53863C8D-20003-2100090A-1FFFF}
Message-ID: <53863E2F.3000406@tilera.com>
Date: Wed, 28 May 2014 15:51:11 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Daniel Walter <dwalter@google.com>, <linux-kernel@vger.kernel.org>
CC: <richard@nod.at>
Subject: Re: [PATCH 01/12] [arch/tile] Remove obsolete strict_strto calls
References: <20140526215932.GC25779@google.com>
In-Reply-To: <20140526215932.GC25779@google.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.9.0.23]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/26/2014 5:59 PM, Daniel Walter wrote:
> From: Daniel Walter<dwalter@google.com>
> Subject: [PATCH 01/12] [arch/tile] replace strict_strto* call with kstrto*
>
> remove obsolete calls to strict_strto* and replace them
> with kstrto* calls accordingly.
>
> Signed-off-by: Daniel Walter<dwalter@google.com>
> ---
>   arch/tile/kernel/setup.c  | 7 ++-----
>   arch/tile/kernel/signal.c | 7 +++----
>   arch/tile/kernel/traps.c  | 5 ++---
>   arch/tile/mm/init.c       | 2 +-
>   4 files changed, 8 insertions(+), 13 deletions(-)

Thanks, taken into the tile tree.

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

