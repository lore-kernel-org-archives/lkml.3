Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752070AbbASVUd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 16:20:33 -0500
Received: from senator.holtmann.net ([87.106.208.187]:57460 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649AbbASVUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 16:20:32 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 8.1 \(1993\))
Subject: Re: [PATCH v2] ath3k: Add support of AR3012 bluetooth 13d3:3423 device
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <1421529411-25385-1-git-send-email-hanipouspilot@gmail.com>
Date: Mon, 19 Jan 2015 13:20:29 -0800
Cc: linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, stable@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <93DF9061-68D9-4C3E-A951-8500EB634734@holtmann.org>
References: <1421529411-25385-1-git-send-email-hanipouspilot@gmail.com>
To: Dmitry Tunin <hanipouspilot@gmail.com>
X-Mailer: Apple Mail (2.1993)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

> Add support of 13d3:3423 device.
> 
> BugLink: https://bugs.launchpad.net/bugs/1411193 
> 
> T: Bus=01 Lev=02 Prnt=03 Port=00 Cnt=01 Dev#= 5 Spd=12 MxCh= 0
> D: Ver= 1.10 Cls=e0(wlcon) Sub=01 Prot=01 MxPS=64 #Cfgs= 1
> P: Vendor=13d3 ProdID=3423 Rev= 0.01
> C:* #Ifs= 2 Cfg#= 1 Atr=e0 MxPwr=100mA
> A: FirstIf#= 0 IfCount= 2 Cls=e0(wlcon) Sub=01 Prot=01
> I:* If#= 0 Alt= 0 #EPs= 3 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
> E: Ad=81(I) Atr=03(Int.) MxPS= 16 Ivl=1ms
> E: Ad=82(I) Atr=02(Bulk) MxPS= 64 Ivl=0ms
> E: Ad=02(O) Atr=02(Bulk) MxPS= 64 Ivl=0ms
> I:* If#= 1 Alt= 0 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
> E: Ad=83(I) Atr=01(Isoc) MxPS= 0 Ivl=1ms
> E: Ad=03(O) Atr=01(Isoc) MxPS= 0 Ivl=1ms
> I: If#= 1 Alt= 1 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
> E: Ad=83(I) Atr=01(Isoc) MxPS= 9 Ivl=1ms
> E: Ad=03(O) Atr=01(Isoc) MxPS= 9 Ivl=1ms
> I: If#= 1 Alt= 2 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
> E: Ad=83(I) Atr=01(Isoc) MxPS= 17 Ivl=1ms
> E: Ad=03(O) Atr=01(Isoc) MxPS= 17 Ivl=1ms
> I: If#= 1 Alt= 3 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
> E: Ad=83(I) Atr=01(Isoc) MxPS= 25 Ivl=1ms
> E: Ad=03(O) Atr=01(Isoc) MxPS= 25 Ivl=1ms
> I: If#= 1 Alt= 4 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
> E: Ad=83(I) Atr=01(Isoc) MxPS= 33 Ivl=1ms
> E: Ad=03(O) Atr=01(Isoc) MxPS= 33 Ivl=1ms
> I: If#= 1 Alt= 5 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
> E: Ad=83(I) Atr=01(Isoc) MxPS= 49 Ivl=1ms
> E: Ad=03(O) Atr=01(Isoc) MxPS= 49 Ivl=1ms
> 
> Signed-off-by: Dmitry Tunin <hanipouspilot@gmail.com>
> Cc: stable@vger.kernel.org
> ---
> drivers/bluetooth/ath3k.c | 2 ++
> drivers/bluetooth/btusb.c | 1 +
> 2 files changed, 3 insertions(+)

patch has been applied to bluetooth-next tree.

Regards

Marcel

