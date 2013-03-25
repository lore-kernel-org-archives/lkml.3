Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933063Ab3CYTzN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 15:55:13 -0400
Received: from mail-qa0-f43.google.com ([209.85.216.43]:48686 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758889Ab3CYTzL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 15:55:11 -0400
Date: Mon, 25 Mar 2013 16:55:04 -0300
From: Gustavo Padovan <gustavo@padovan.org>
To: Noguchi Kazutosi <linux@mofmof.scaltinof.net>
Cc: marcel@holtmann.org, johan.hedberg@gmail.com,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Bluetooth: Add support for Foxconn / Hon Hai [0489:e04d]
 Add support for the AR3012 chip in SONY SVS13129.
Message-ID: <20130325195504.GA15335@joana>
Mail-Followup-To: Gustavo Padovan <gustavo@padovan.org>,
	Noguchi Kazutosi <linux@scaltinof.net>, marcel@holtmann.org,
	johan.hedberg@gmail.com, linux-bluetooth@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <1364136070-4426-1-git-send-email-linux@scaltinof.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364136070-4426-1-git-send-email-linux@scaltinof.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Noguchi,

* Noguchi Kazutosi <linux@scaltinof.net> [2013-03-24 23:41:10 +0900]:

> T:  Bus=01 Lev=02 Prnt=02 Port=05 Cnt=03 Dev#= 21 Spd=12  MxCh= 0
> D:  Ver= 1.10 Cls=e0(wlcon) Sub=01 Prot=01 MxPS=64 #Cfgs=  1
> P:  Vendor=0489 ProdID=e04d Rev=00.02
> S:  Manufacturer=Atheros Communications
> S:  Product=Bluetooth USB Host Controller
> S:  SerialNumber=Alaska Day 2006
> C:  #Ifs= 2 Cfg#= 1 Atr=e0 MxPwr=100mA
> I:  If#= 0 Alt= 0 #EPs= 3 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
> I:  If#= 1 Alt= 0 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
> 
> Signed-off-by: Noguchi Kazutosi <linux@scaltinof.net>
> ---
>  drivers/bluetooth/ath3k.c |    2 ++
>  drivers/bluetooth/btusb.c |    1 +
>  2 files changed, 3 insertions(+)

Patch has been applied to bluetooth-next. Thanks.

	Gustavo
