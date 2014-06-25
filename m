Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752978AbaFYGEY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 02:04:24 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:58575 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752469AbaFYGEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 02:04:23 -0400
Date: Wed, 25 Jun 2014 07:59:18 +0200
From: Henrik Austad <henrik@austad.us>
To: Henrik Austad <haustad@cisco.com>
Cc: "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] ether: add AVB frame type ETH_P_AVB
Message-ID: <20140625055918.GA19864@austad.us>
References: <1402047773-2320-1-git-send-email-haustad@cisco.com>
 <5391942E.8020507@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5391942E.8020507@cisco.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 06, 2014 at 12:13:02PM +0200, Henrik Austad wrote:
> David,

Hi, ACK/NACK on this?

Thanks,

Henrik

> I messed up the keys on my keyboard and shipped the patch without CC
> to you. Sorry!
> 
> - Henrik
> 
> On 06/06/2014 11:42 AM, Henrik Austad wrote:
> >Audio/Video Bridging over layer-2 transport protocol uses 0x22F0 as
> >packet type. This type is used for both AVB control data as well as AVB
> >media streams.
> >
> 
> CC: "David S. Miller" <davem@davemloft.net>
> 
> >Signed-off-by: Henrik Austad <haustad@cisco.com>
> >---
> >  include/uapi/linux/if_ether.h | 1 +
> >  1 file changed, 1 insertion(+)
> >
> >diff --git a/include/uapi/linux/if_ether.h b/include/uapi/linux/if_ether.h
> >index 0f8210b..c8147de 100644
> >--- a/include/uapi/linux/if_ether.h
> >+++ b/include/uapi/linux/if_ether.h
> >@@ -48,6 +48,7 @@
> >  #define	ETH_P_BPQ	0x08FF		/* G8BPQ AX.25 Ethernet Packet	[ NOT AN OFFICIALLY REGISTERED ID ] */
> >  #define ETH_P_IEEEPUP	0x0a00		/* Xerox IEEE802.3 PUP packet */
> >  #define ETH_P_IEEEPUPAT	0x0a01		/* Xerox IEEE802.3 PUP Addr Trans packet */
> >+#define ETH_P_AVB	0x22F0		/* IEEE 1722 AVB frame          [ NOT AN OFFICIALLY REGISTERED ID ] */
> >  #define ETH_P_BATMAN	0x4305		/* B.A.T.M.A.N.-Advanced packet [ NOT AN OFFICIALLY REGISTERED ID ] */
> >  #define ETH_P_DEC       0x6000          /* DEC Assigned proto           */
> >  #define ETH_P_DNA_DL    0x6001          /* DEC DNA Dump/Load            */
> >
> 
> -- 
> Henrik Austad
> Software Engineer
> TIPBU Eng, Performance
> 
> Sent from my computer

-- 
Henrik Austad
