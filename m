Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934982Ab3BTT6f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 14:58:35 -0500
Received: from smtp12.ono.com ([62.42.230.20]:15445 "EHLO resmaa12.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934926Ab3BTT6d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 14:58:33 -0500
Message-ID: <51252AE7.7040903@ono.com>
Date: Wed, 20 Feb 2013 20:58:31 +0100
From: =?UTF-8?B?SkEgTWFnYWxsw7Nu?= <jamagallon@ono.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130114 Thunderbird/17.0.2
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Corrupt packets with ath5k
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all...

I have a strange problem with latest kernels. When I update my netbook
I get many "Installation failed, bad rpms:" mesages. First I thougt
that the oldie cheap ssd was failing (it is an Aspire AOA110).
But the updates work always fine when plugged to ethernet.

Now i tried to copy a couple RPMS via ssh over wifi and got:

mplayer-1.1-11.r35916.1.mga3.tainted.i586.rpm  100% 2192KB   2.1MB/s   00:00
Received disconnect from 192.168.1.51: 2: Packet corrupt
lost connection

Hardware/driver are these:

03:00.0 Ethernet controller: Atheros Communications Inc. AR242x / AR542x Wireless Network Adapter (PCI-Express) (rev 01)
	Subsystem: Foxconn International, Inc. Device e008
	Kernel driver in use: ath5k

Ist that hardware failing ? Is driver failing ? Other laptop/androids
update fine with the router via wifi.
Any idea ?

I currently have 3.8.0, distro build.

TIA

-- 
J.A. Magallon <jamagallon()ono!com>        \               Winter is coming...
