Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932794Ab3HNQ3a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 12:29:30 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:58613 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932352Ab3HNQ33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 12:29:29 -0400
Message-ID: <520BB068.3070607@tilera.com>
Date: Wed, 14 Aug 2013 12:29:28 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Akinobu Mita <akinobu.mita@gmail.com>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tile: use asm-generic/bitops/builtin-*.h
References: <1376485650-5227-1-git-send-email-akinobu.mita@gmail.com>
In-Reply-To: <1376485650-5227-1-git-send-email-akinobu.mita@gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/14/2013 9:07 AM, Akinobu Mita wrote:
> The definisions of __ffs(), __fls(), and ffs() for tile are almost same
> as asm-generic/bitops-*.h.  The only difference is that it is defined
> as __always_inline or inline.  So this switches to use those headers.
>
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> Cc: Chris Metcalf <cmetcalf@tilera.com>
> ---
>  arch/tile/include/asm/bitops.h | 38 +++-----------------------------------
>  1 file changed, 3 insertions(+), 35 deletions(-)

Thanks; taken into the tile tree (though I moved the new #includes to the end of the header with the other asm-generic #includes).

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

