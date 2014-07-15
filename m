Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758680AbaGOJ47 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 05:56:59 -0400
Received: from darkcity.gna.ch ([195.226.6.51]:43753 "EHLO mail.gna.ch"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758430AbaGOJ4z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 05:56:55 -0400
Message-ID: <53C4FAD9.1020008@daenzer.net>
Date: Tue, 15 Jul 2014 18:56:41 +0900
From: =?windows-1252?Q?Michel_D=E4nzer?= <michel@daenzer.net>
User-Agent: Mozilla/5.0 (X11; Linux ppc; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Hayes Wang <hayeswang@realtek.com>, Francois Romieu <romieu@fr.zoreil.com>,
        nic_swsd <nic_swsd@realtek.com>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] r8169: Enable RX_MULTI_EN for RTL_GIGA_MAC_VER_40
References: <1405406500-1208-1-git-send-email-michel@daenzer.net> <0835B3720019904CB8F7AA43166CEEB25066DC@RTITMBSV03.realtek.com.tw>
In-Reply-To: <0835B3720019904CB8F7AA43166CEEB25066DC@RTITMBSV03.realtek.com.tw>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15.07.2014 18:29, Hayes Wang wrote:
>  Michel Dänzer [mailto:michel@daenzer.net] 
>> Sent: Tuesday, July 15, 2014 2:42 PM
>> To: Francois Romieu; nic_swsd
>> Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org
>> Subject: [PATCH] r8169: Enable RX_MULTI_EN for RTL_GIGA_MAC_VER_40
>>
>> Without this, the ethernet port on my ASUS A88X Pro mainboard stops
>> working sometimes, with messages like these in dmesg:
>>
>> AMD-Vi: Event logged [IO_PAGE_FAULT device=05:00.0 
>> domain=0x001e address=0x0000000000003000 flags=0x0050]
> 
> I search the information about your issue. It seems to be
> relative to the IOMMU. I don't sure if your patch is the root
> cause or a workaround.

It's quite possibly just a workaround; I tried this based on previous
similar commits in this driver.


-- 
Earthling Michel Dänzer            |                  http://www.amd.com
Libre software enthusiast          |                Mesa and X developer
