Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754226AbaGHPV0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 11:21:26 -0400
Received: from senator.holtmann.net ([87.106.208.187]:36018 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927AbaGHPVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 11:21:24 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: [PATCH] Bluetooth: Add support for Acer [13D3:3432]
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <1404827708-23154-1-git-send-email-ananthk@codeaurora.org>
Date: Tue, 8 Jul 2014 17:21:22 +0200
Cc: "Gustavo F. Padovan" <gustavo@padovan.org>,
        Linux Bluetooth mailing list 
	<linux-bluetooth@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <410ABCB7-4D78-4126-AECA-03E3A3D5A13B@holtmann.org>
References: <1404827708-23154-1-git-send-email-ananthk@codeaurora.org>
To: Anantha Krishnan <ananthk@codeaurora.org>
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Anantha,

> Add support for the QCA6174 chip.
> 
>    T:  Bus=04 Lev=01 Prnt=01 Port=00 Cnt=01 Dev#= 30 Spd=12  MxCh= 0
>    D:  Ver= 1.10 Cls=e0(wlcon) Sub=01 Prot=01 MxPS=64 #Cfgs=  1
>    P:  Vendor=13d3 ProdID=3432 Rev=00.02
>    C:  #Ifs= 2 Cfg#= 1 Atr=e0 MxPwr=100mA
>    I:  If#= 0 Alt= 0 #EPs= 3 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
>    I:  If#= 1 Alt= 0 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
> 
> Signed-off-by: Anantha Krishnan <ananthk@codeaurora.org>
> ---
> drivers/bluetooth/ath3k.c | 2 ++
> drivers/bluetooth/btusb.c | 1 +
> 2 files changed, 3 insertions(+)

patch has been applied to bluetooth-next tree.

Regards

Marcel

