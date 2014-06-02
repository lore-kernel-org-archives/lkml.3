Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753992AbaFBVHs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 17:07:48 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:40400 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169AbaFBVHr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 17:07:47 -0400
X-CheckPoint: {538CE7A2-4-2100090A-C0000000}
Message-ID: <538CE7A1.5010107@tilera.com>
Date: Mon, 2 Jun 2014 17:07:45 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Fabian Frederick <fabf@skynet.be>, <linux-kernel@vger.kernel.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 1/1 linux-next] drivers/tty/hvc/hvc_tile.c: use PTR_ERR_OR_ZERO
References: <1401623783-3271-1-git-send-email-fabf@skynet.be>
In-Reply-To: <1401623783-3271-1-git-send-email-fabf@skynet.be>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.9.0.23]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/1/2014 7:56 AM, Fabian Frederick wrote:
> replace IS_ERR/PTR_ERR
>
> Cc: Chris Metcalf <cmetcalf@tilera.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> ---
> This is untested.
>
>   drivers/tty/hvc/hvc_tile.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)

Thanks, taken into the linux-tile tree.

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

