Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757640AbaGQToK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 15:44:10 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:30922 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754796AbaGQToH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 15:44:07 -0400
X-CheckPoint: {53C82786-2-2100090A-C0000000}
Message-ID: <53C82786.2080609@tilera.com>
Date: Thu, 17 Jul 2014 15:44:06 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>, Arnd Bergmann <arnd@arndb.de>
CC: lkml <linux-kernel@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>
Subject: Re: [PATCH 34/38] tile: clean-up uapi Kbuild file
References: <20140714150609.GA28358@ravnborg.org> <1405350546-28467-1-git-send-email-sam@ravnborg.org> <1405350546-28467-34-git-send-email-sam@ravnborg.org>
In-Reply-To: <1405350546-28467-34-git-send-email-sam@ravnborg.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.9.0.23]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/14/2014 11:09 AM, Sam Ravnborg wrote:
> Remove redundant assignments.
>
> Signed-off-by: Sam Ravnborg<sam@ravnborg.org>
> Cc: Chris Metcalf<cmetcalf@tilera.com>
> ---
>   arch/tile/include/uapi/asm/Kbuild | 14 +-------------
>   1 file changed, 1 insertion(+), 13 deletions(-)

Acked-by: Chris Metcalf <cmetcalf@tilera.com>

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

