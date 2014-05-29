Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757226AbaE2KpZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 06:45:25 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:33248 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752220AbaE2KpY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 06:45:24 -0400
Date: Thu, 29 May 2014 12:45:16 +0200
From: Alexander Aring <alex.aring@gmail.com>
To: Varka Bhadram <varkabhadram@gmail.com>
Cc: alan@signal11.us, Varka Bhadram <varkab@cdac.in>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-zigbee-devel@lists.sourceforge.net,
        alex.aing@gmail.com, davem@davemloft.net
Subject: Re: [Linux-zigbee-devel] [PATCH net-next v3] mrf24j40: added device
 managed APIs
Message-ID: <20140529104514.GA26416@omega>
References: <1401359258-7247-1-git-send-email-varkab@cdac.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1401359258-7247-1-git-send-email-varkab@cdac.in>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Varka,


On Thu, May 29, 2014 at 03:57:38PM +0530, Varka Bhadram wrote:
> changes since v2:
> 1. removed unwanted label implementation. 
> 
> When we use devm_* APIs ,probe() failed also the memory
> will be freed automatically. Thanks to Alex
> 
> -Varka Bhadram
> 
> 

you should provide a "well" commit msg here. No emotional comments and
remove your signature.

Look in linux tree and run "git log" for other commit messages.

> Signed-off-by: Varka Bhadram <varkab@cdac.in>
> ---

if you want to thanks somebody here and tell about the changes since v2
you can put it here, after the "---". This will be ignored while applying your patch.

>  drivers/net/ieee802154/mrf24j40.c |   30 ++++++++++++------------------
>  1 file changed, 12 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/net/ieee802154/mrf24j40.c b/drivers/net/ieee802154/mrf24j40.c
> index 78a6552..f2b1345 100644
> --- a/drivers/net/ieee802154/mrf24j40.c
> +++ b/drivers/net/ieee802154/mrf24j40.c

- Alex
