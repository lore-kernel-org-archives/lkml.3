Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752620Ab3EISCg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 14:02:36 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:52850 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752464Ab3EISCf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 14:02:35 -0400
Message-ID: <518BE4BA.9050604@tilera.com>
Date: Thu, 9 May 2013 14:02:34 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Denis Efremov <yefremov.denis@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <trivial@kernel.org>,
        <ldv-project@linuxtesting.org>
Subject: Re: [PATCH 15/21] arch/tile: remove inline marking of EXPORT_SYMBOL
 functions
References: <1368086241-9357-1-git-send-email-yefremov.denis@gmail.com> <1368095819-11011-4-git-send-email-yefremov.denis@gmail.com>
In-Reply-To: <1368095819-11011-4-git-send-email-yefremov.denis@gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/9/2013 6:36 AM, Denis Efremov wrote:
> EXPORT_SYMBOL and inline directives are contradictory to each other.
> The patch fixes this inconsistency.
>
> Found by Linux Driver Verification project (linuxtesting.org).
>
> Signed-off-by: Denis Efremov <yefremov.denis@gmail.com>
> ---
>  arch/tile/lib/spinlock_32.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Thanks, taken into the tile tree.

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

