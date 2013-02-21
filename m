Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752917Ab3BUA3y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 19:29:54 -0500
Received: from smtp13.ono.com ([62.42.230.16]:22253 "EHLO resmaa13.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751644Ab3BUA3x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 19:29:53 -0500
Message-ID: <51256A7F.7010207@ono.com>
Date: Thu, 21 Feb 2013 01:29:51 +0100
From: =?UTF-8?B?SkEgTWFnYWxsw7Nu?= <jamagallon@ono.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130114 Thunderbird/17.0.2
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Corrupt packets with ath5k
References: <51252AE7.7040903@ono.com>
In-Reply-To: <51252AE7.7040903@ono.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/20/2013 08:58 PM, JA Magallón wrote:
> Hi all...
>
> I have a strange problem with latest kernels. When I update my netbook
> I get many "Installation failed, bad rpms:" mesages. First I thougt
> that the oldie cheap ssd was failing (it is an Aspire AOA110).
> But the updates work always fine when plugged to ethernet.
>
> Now i tried to copy a couple RPMS via ssh over wifi and got:
>
> mplayer-1.1-11.r35916.1.mga3.tainted.i586.rpm  100% 2192KB   2.1MB/s   00:00
> Received disconnect from 192.168.1.51: 2: Packet corrupt
> lost connection
>
> Hardware/driver are these:
>
> 03:00.0 Ethernet controller: Atheros Communications Inc. AR242x / AR542x Wireless Network Adapter (PCI-Express) (rev 01)
>      Subsystem: Foxconn International, Inc. Device e008
>      Kernel driver in use: ath5k
>
> Ist that hardware failing ? Is driver failing ? Other laptop/androids
> update fine with the router via wifi.
> Any idea ?
>
> I currently have 3.8.0, distro build.
>

I tried with 3.7.1 and everything works fine.
Possible clues:
- 3.7.1: works fine
- warm boot in 3.8.0: transfer stalls and scp looks hanged, speed
   drops to zero, but no error message
- cold boot in 3.8.0: transfer stops with Packet corrupt error or sometimes
   stalls..

> TIA
>


-- 
J.A. Magallon <jamagallon()ono!com>        \               Winter is coming...
