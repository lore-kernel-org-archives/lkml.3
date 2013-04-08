Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934728Ab3DHQRc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 12:17:32 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:64299 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934579Ab3DHQRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 12:17:31 -0400
Message-ID: <5162ED97.3080804@gmail.com>
Date: Mon, 08 Apr 2013 18:17:27 +0200
From: Sergio Callegari <sergio.callegari@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Kernel panic on kernel 3.8.x, 3.9RC6 when closing bluetooth dun connection
 (regression from 3.7.x)
References: <51498CFE.9060804@gmail.com> <20130320161712.GA27840@kroah.com>
In-Reply-To: <20130320161712.GA27840@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm following up with a previous email where I was reporting a systematic kernel 
panic/system freeze when closing a bluetooth DUN connection.

I have made a few more tests, all with 64 bit machines:

- Bug happens with all the 3.8.x kernel series, up to the latest 3.8.6
- Bug happens with the 3.9RC6 kernel
- Bug is not present up to 3.7.x, including the latest 3.7.10
- Bug happens on the DELL E6500 laptop that has a Dell Computer Corp. Wireless 
370 Bluetooth Mini-card
- Bug also happens on a desktop that has a Cambridge Silicon Radio, Ltd 
Bluetooth Dongle (HCI mode)

Let me recall that the bug is triggered by connecting to the internet via a 
mobile phone, using bluetooth DUN and then disconnecting. Kernel panics on 
disconnection (the phone I am using is a Samsung Galaxy S Plus)

- Bug does not happen on the same machines when connecting to the internet via 
ppp using a usb gsm/umts dongle and the same provider, so the bug seems to be BT 
related and not common to all internet connections using a Point to Point serial 
protocol.

Unfortunately, I see the bug on a machine that I use for day by day work and
I cannot afford bisecting here.

Nonetheless, the bug seems easy to reproduce (I catched it on two different 
machines with different setups). So I hope this note can help haunting the 
regression anyway.

Thanks for the attention,

Sergio Callegari
