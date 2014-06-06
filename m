Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752154AbaFFKgB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 06:36:01 -0400
Received: from aer-iport-3.cisco.com ([173.38.203.53]:2761 "EHLO
	aer-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751635AbaFFKf7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 06:35:59 -0400
X-Greylist: delayed 588 seconds by postgrey-1.27 at vger.kernel.org; Fri, 06 Jun 2014 06:35:59 EDT
X-IronPort-AV: E=Sophos;i="4.98,988,1392163200"; 
   d="scan'208";a="71725855"
Message-ID: <5391942E.8020507@cisco.com>
Date: Fri, 06 Jun 2014 12:13:02 +0200
From: Henrik Austad <haustad@cisco.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: "David S. Miller" <davem@davemloft.net>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, henrik@austad.us
Subject: Re: [PATCH] ether: add AVB frame type ETH_P_AVB
References: <1402047773-2320-1-git-send-email-haustad@cisco.com>
In-Reply-To: <1402047773-2320-1-git-send-email-haustad@cisco.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David,

I messed up the keys on my keyboard and shipped the patch without CC to 
you. Sorry!

- Henrik

On 06/06/2014 11:42 AM, Henrik Austad wrote:
> Audio/Video Bridging over layer-2 transport protocol uses 0x22F0 as
> packet type. This type is used for both AVB control data as well as AVB
> media streams.
>

CC: "David S. Miller" <davem@davemloft.net>

> Signed-off-by: Henrik Austad <haustad@cisco.com>
> ---
>   include/uapi/linux/if_ether.h | 1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/include/uapi/linux/if_ether.h b/include/uapi/linux/if_ether.h
> index 0f8210b..c8147de 100644
> --- a/include/uapi/linux/if_ether.h
> +++ b/include/uapi/linux/if_ether.h
> @@ -48,6 +48,7 @@
>   #define	ETH_P_BPQ	0x08FF		/* G8BPQ AX.25 Ethernet Packet	[ NOT AN OFFICIALLY REGISTERED ID ] */
>   #define ETH_P_IEEEPUP	0x0a00		/* Xerox IEEE802.3 PUP packet */
>   #define ETH_P_IEEEPUPAT	0x0a01		/* Xerox IEEE802.3 PUP Addr Trans packet */
> +#define ETH_P_AVB	0x22F0		/* IEEE 1722 AVB frame          [ NOT AN OFFICIALLY REGISTERED ID ] */
>   #define ETH_P_BATMAN	0x4305		/* B.A.T.M.A.N.-Advanced packet [ NOT AN OFFICIALLY REGISTERED ID ] */
>   #define ETH_P_DEC       0x6000          /* DEC Assigned proto           */
>   #define ETH_P_DNA_DL    0x6001          /* DEC DNA Dump/Load            */
>

-- 
Henrik Austad
Software Engineer
TIPBU Eng, Performance

Sent from my computer
