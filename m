Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752308AbaKZIEi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 03:04:38 -0500
Received: from mail-la0-f50.google.com ([209.85.215.50]:57688 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751764AbaKZIEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 03:04:36 -0500
Message-ID: <54758990.2050908@gmail.com>
Date: Wed, 26 Nov 2014 11:04:32 +0300
From: Dmitry Tunin <hanipouspilot@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Marcel Holtmann <marcel@holtmann.org>
CC: linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH v6] ath3k: Add support of MCI 13d3:3408 bt device
References: <5474BA38.2070908@gmail.com> <C8849DFB-5159-4C62-A861-D393034E4895@holtmann.org>
In-Reply-To: <C8849DFB-5159-4C62-A861-D393034E4895@holtmann.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I spent already hours on sending this fucking email. The patch works for 
me. And if someone else is interested in working of this device feel 
free and do it yourself.

26.11.2014 08:05, Marcel Holtmann wrote:
> Hi Dmitry,
>
>> Add support for bluetooth MCI WB335 (AR9565) Wi-Fi+bt module.
>> This bluetooth module requires loading patch and sysconfig by ath3k driver.
>>
>> T:  Bus=01 Lev=02 Prnt=03 Port=00 Cnt=01 Dev#= 20 Spd=12   MxCh= 0
>> D:  Ver= 1.10 Cls=e0(wlcon) Sub=01 Prot=01 MxPS=64 #Cfgs=  1
>> P:  Vendor=13d3 ProdID=3408 Rev= 0.02
>> C:* #Ifs= 2 Cfg#= 1 Atr=e0 MxPwr=100mA
>> A:  FirstIf#= 0 IfCount= 2 Cls=e0(wlcon) Sub=01 Prot=01
>> I:* If#= 0 Alt= 0 #EPs= 3 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
>> E:  Ad=81(I) Atr=03(Int.) MxPS=  16 Ivl=1ms
>> E:  Ad=82(I) Atr=02(Bulk) MxPS=  64 Ivl=0ms
>> E:  Ad=02(O) Atr=02(Bulk) MxPS=  64 Ivl=0ms
>> I:* If#= 1 Alt= 0 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
>> E:  Ad=83(I) Atr=01(Isoc) MxPS=   0 Ivl=1ms
>> E:  Ad=03(O) Atr=01(Isoc) MxPS=   0 Ivl=1ms
>> I:  If#= 1 Alt= 1 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
>> E:  Ad=83(I) Atr=01(Isoc) MxPS=   9 Ivl=1ms
>> E:  Ad=03(O) Atr=01(Isoc) MxPS=   9 Ivl=1ms
>> I:  If#= 1 Alt= 2 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
>> E:  Ad=83(I) Atr=01(Isoc) MxPS=  17 Ivl=1ms
>> E:  Ad=03(O) Atr=01(Isoc) MxPS=  17 Ivl=1ms
>> I:  If#= 1 Alt= 3 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
>> E:  Ad=83(I) Atr=01(Isoc) MxPS=  25 Ivl=1ms
>> E:  Ad=03(O) Atr=01(Isoc) MxPS=  25 Ivl=1ms
>> I:  If#= 1 Alt= 4 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
>> E:  Ad=83(I) Atr=01(Isoc) MxPS=  33 Ivl=1ms
>> E:  Ad=03(O) Atr=01(Isoc) MxPS=  33 Ivl=1ms
>> I:  If#= 1 Alt= 5 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
>> E:  Ad=83(I) Atr=01(Isoc) MxPS=  49 Ivl=1ms
>> E:  Ad=03(O) Atr=01(Isoc) MxPS=  49 Ivl=1ms
>>
>>
>> CC: stable@vger.kernel.org
>> Signed-off-by: Dmitry Tunin <hanipouspilot@gmail.com>
>
> so you really need to make sure to send only one version. I now have two patches labeled as v6 and I have no idea which one is recent and which one I am suppose to apply.
>
> I tried applying this one, but it failed. Patches need to be based against bluetooth-next tree.
>
> Applying: ath3k: Add support of MCI 13d3:3408 bt device
> error: patch failed: drivers/bluetooth/ath3k.c:105
> error: drivers/bluetooth/ath3k.c: patch does not apply
> error: patch failed: drivers/bluetooth/btusb.c:182
> error: drivers/bluetooth/btusb.c: patch does not apply
> Patch failed at 0001 ath3k: Add support of MCI 13d3:3408 bt device
>
> Regards
>
> Marcel
>
