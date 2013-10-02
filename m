Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753333Ab3JBH1Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 03:27:16 -0400
Received: from mms1.broadcom.com ([216.31.210.17]:4510 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752784Ab3JBH1N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 03:27:13 -0400
X-Server-Uuid: 06151B78-6688-425E-9DE2-57CB27892261
Message-ID: <524BCAC4.6060209@broadcom.com>
Date: Wed, 2 Oct 2013 09:27:00 +0200
From: "Arend van Spriel" <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.0
MIME-Version: 1.0
To: "Joe Perches" <joe@perches.com>, netdev <netdev@vger.kernel.org>
cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        e1000-devel@lists.sourceforge.net, linux-usb@vger.kernel.org,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        wil6210@qca.qualcomm.com, b43-dev@lists.infradead.org,
        brcm80211-dev-list@broadcom.com, bridge@lists.linux-foundation.org,
        netfilter-devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH net-next] net:drivers/net: Miscellaneous conversions
 to ETH_ALEN
References: <1380679480.2081.24.camel@joe-AO722>
In-Reply-To: <1380679480.2081.24.camel@joe-AO722>
X-WSS-ID: 7E5515430UO13057374-01-01
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/02/2013 04:04 AM, Joe Perches wrote:
> Convert the memset/memcpy uses of 6 to ETH_ALEN
> where appropriate.
>
> Also convert some struct definitions and u8 array
> declarations of [6] to ETH_ALEN.
>
For brcmsmac

Acked-by: Arend van Spriel <arend@broadcom.com>
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>   drivers/net/wireless/brcm80211/brcmsmac/main.c     |  6 +-


