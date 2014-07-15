Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759527AbaGOVyZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 17:54:25 -0400
Received: from violet.fr.zoreil.com ([92.243.8.30]:36803 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759643AbaGOVyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 17:54:20 -0400
Date: Tue, 15 Jul 2014 23:54:12 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Hayes Wang <hayeswang@realtek.com>
Cc: Michel =?utf-8?Q?D=C3=A4nzer?= <michel@daenzer.net>,
        nic_swsd <nic_swsd@realtek.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] r8169: Enable RX_MULTI_EN for RTL_GIGA_MAC_VER_40
Message-ID: <20140715215412.GA19363@electric-eye.fr.zoreil.com>
References: <1405406500-1208-1-git-send-email-michel@daenzer.net>
 <0835B3720019904CB8F7AA43166CEEB25066DC@RTITMBSV03.realtek.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0835B3720019904CB8F7AA43166CEEB25066DC@RTITMBSV03.realtek.com.tw>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hayes Wang <hayeswang@realtek.com> :
>  Michel D?nzer [mailto:michel@daenzer.net] 
[...]
> > Without this, the ethernet port on my ASUS A88X Pro mainboard stops
> > working sometimes, with messages like these in dmesg:
> > 
> > AMD-Vi: Event logged [IO_PAGE_FAULT device=05:00.0 
> > domain=0x001e address=0x0000000000003000 flags=0x0050]
> 
> I search the information about your issue. It seems to be
> relative to the IOMMU. I don't sure if your patch is the root
> cause or a workaround.

Btw, a few extra identifiers in rtl_init_rxcfg may improve consistency:

           missing             |          included
-------------------------------+-------------------------------
RTL_GIGA_MAC_VER_36 (8168f)    | RTL_GIGA_MAC_VER_35 (8168f)
RTL_GIGA_MAC_VER_38 (RTL8411)  | RTL_GIGA_MAC_VER_44 (RTL8411)
RTL_GIGA_MAC_VER_39 (RTL8106e) | RTL_GIGA_MAC_VER_43 (RTL8106e)
RTL_GIGA_MAC_VER_37 (RTL8402)  |

-- 
Ueimor
