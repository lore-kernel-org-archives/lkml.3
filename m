Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752923Ab3GXUg2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 16:36:28 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:39366 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579Ab3GXUg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 16:36:27 -0400
Message-ID: <51F03AC6.6050208@openvz.org>
Date: Thu, 25 Jul 2013 00:36:22 +0400
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130119 Firefox/10.0.11esrpre Iceape/2.7.12
MIME-Version: 1.0
To: "Winkler, Tomas" <tomas.winkler@intel.com>
CC: "Shuah Khan (shuah.kh@samsung.com)" <shuah.kh@samsung.com>,
        "'arnd@arndb.de'" <arnd@arndb.de>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'gregkh@linuxfoundation.org'" <gregkh@linuxfoundation.org>
Subject: Re: [char-misc 0/4 3.11] Fix mei suspend/resume failure
References: <1374063197-26855-1-git-send-email-tomas.winkler@intel.com> <5B8DA87D05A7694D9FA63FD143655C1B028EBE55@HASMSX106.ger.corp.intel.com> <5B8DA87D05A7694D9FA63FD143655C1B1AE65788@HASMSX106.ger.corp.intel.com> <51F0321B.4040005@openvz.org> <5B8DA87D05A7694D9FA63FD143655C1B1AE73A9C@HASMSX106.ger.corp.intel.com>
In-Reply-To: <5B8DA87D05A7694D9FA63FD143655C1B1AE73A9C@HASMSX106.ger.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Winkler, Tomas wrote:
>
>
>>
>> Winkler, Tomas wrote:
>>>>
>>>>
>>>>>
>>>>> This series should fix the long standing reset storm issue in mei
>>>>> suspend/resume failure
>>>>>
>>>
>>> Can you guys confirm these fixes the issue for you.
>>> Thanks
>>> Tomas
>>
>> Nope, it's still broken
>>
>> kernel: 3.10.2 + my patch for i915 + four your patches. config in attachment
>>
>
> Very surprising,
> Can you send me the pci ids of the mei device on your platform.

8086:1c3a

00:16.0 Communication controller: Intel Corporation 6 Series/C200 Series Chipset Family MEI Controller #1 (rev 04)
	Subsystem: Lenovo Device 21da
	Control: I/O- Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx+
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at f2625000 (64-bit, non-prefetchable) [size=16]
	Capabilities: [50] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [8c] MSI: Enable- Count=1/1 Maskable- 64bit+
		Address: 00000000fee0f00c  Data: 4187


> Thanks
> Tomas

