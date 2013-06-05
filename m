Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756205Ab3FEOg5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 10:36:57 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:47849 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756063Ab3FEOgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 10:36:53 -0400
Date: Wed, 5 Jun 2013 15:36:48 +0100
From: Gustavo Padovan <gustavo@padovan.org>
To: "Cho, Yu-Chen" <acho@suse.com>
Cc: marcel@holtmann.org, johan.hedberg@gmail.com,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        oneukum@suse.com, jlee@suse.com, jay.hung@mediatek.com
Subject: Re: [PATCH] Bluetooth: Add support for Mediatek Bluetooth device
 [0e8d:763f]
Message-ID: <20130605143648.GB3043@joana>
Mail-Followup-To: Gustavo Padovan <gustavo@padovan.org>,
	"Cho, Yu-Chen" <acho@suse.com>, marcel@holtmann.org,
	johan.hedberg@gmail.com, linux-bluetooth@vger.kernel.org,
	linux-kernel@vger.kernel.org, oneukum@suse.com, jlee@suse.com,
	jay.hung@mediatek.com
References: <1370353226-11058-1-git-send-email-acho@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370353226-11058-1-git-send-email-acho@suse.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Cho,

* Cho, Yu-Chen <acho@suse.com> [2013-06-04 21:40:26 +0800]:

> From: "Cho, Yu-Chen" <acho@suse.com>
> 
> This patch adds support for Mediatek Bluetooth device
> 
> T:  Bus=02 Lev=01 Prnt=01 Port=03 Cnt=01 Dev#=  2 Spd=480  MxCh= 0
> D:  Ver= 2.01 Cls=ef(misc ) Sub=02 Prot=01 MxPS=64 #Cfgs=  1
> P:  Vendor=0e8d ProdID=763f Rev= 1.00
> S:  Manufacturer=MediaTek
> S:  Product=BT
> S:  SerialNumber=1.0
> C:* #Ifs= 2 Cfg#= 1 Atr=a0 MxPwr=450mA
> A:  FirstIf#= 0 IfCount= 2 Cls=ff(vend.) Sub=ff Prot=ff
> I:* If#= 0 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=ff Driver=(none)
> E:  Ad=81(I) Atr=03(Int.) MxPS=  16 Ivl=125us
> E:  Ad=02(O) Atr=02(Bulk) MxPS= 512 Ivl=125us
> E:  Ad=82(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
> I:* If#= 1 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=(none)
> E:  Ad=03(O) Atr=01(Isoc) MxPS=   0 Ivl=1ms
> E:  Ad=83(I) Atr=01(Isoc) MxPS=   0 Ivl=1ms
> I:  If#= 1 Alt= 1 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=(none)
> E:  Ad=03(O) Atr=01(Isoc) MxPS=   9 Ivl=1ms
> E:  Ad=83(I) Atr=01(Isoc) MxPS=   9 Ivl=1ms
> I:  If#= 1 Alt= 2 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=(none)
> E:  Ad=03(O) Atr=01(Isoc) MxPS=  17 Ivl=1ms
> E:  Ad=83(I) Atr=01(Isoc) MxPS=  17 Ivl=1ms
> I:  If#= 1 Alt= 3 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=(none)
> E:  Ad=03(O) Atr=01(Isoc) MxPS=  25 Ivl=1ms
> E:  Ad=83(I) Atr=01(Isoc) MxPS=  25 Ivl=1ms
> I:  If#= 1 Alt= 4 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=(none)
> E:  Ad=03(O) Atr=01(Isoc) MxPS=  33 Ivl=1ms
> E:  Ad=83(I) Atr=01(Isoc) MxPS=  33 Ivl=1ms
> I:  If#= 1 Alt= 5 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=(none)
> E:  Ad=03(O) Atr=01(Isoc) MxPS=  49 Ivl=1ms
> E:  Ad=83(I) Atr=01(Isoc) MxPS=  49 Ivl=1ms
> I:  If#= 1 Alt= 6 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=(none)
> E:  Ad=03(O) Atr=01(Isoc) MxPS=  63 Ivl=1ms
> E:  Ad=83(I) Atr=01(Isoc) MxPS=  63 Ivl=1ms
> 
> Signed-off-by: Cho, Yu-Chen <acho@suse.com>
> ---
>  drivers/bluetooth/btusb.c | 3 +++
>  1 file changed, 3 insertions(+)

Patch has been applied to bluetooth.git. Thanks.

	Gustavo
