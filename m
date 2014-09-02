Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752423AbaIBDBl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 23:01:41 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:41394 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751436AbaIBDBk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 23:01:40 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.39 with qID s82310DZ009639, This message is accepted by code: ctloc85258
From: Hayes Wang <hayeswang@realtek.com>
To: Zhang Rui <rui.zhang@intel.com>, nic_swsd <nic_swsd@realtek.com>
CC: "fireandfuel@hotmail.de" <fireandfuel@hotmail.de>,
        LKML <linux-kernel@vger.kernel.org>
Subject: RE: Regression:  Wake up from Suspend to RAM crashes ToshibaSatellitelaptop to black screen
Thread-Topic: Regression:  Wake up from Suspend to RAM crashes Toshiba
 Satellitelaptop to black screen
Thread-Index: AQHPxbv4sO0CgarWu0WbRG4BR8GSlZvtJcAg
Date: Tue, 2 Sep 2014 03:01:00 +0000
Message-ID: <0835B3720019904CB8F7AA43166CEEB2516CC5@RTITMBSV03.realtek.com.tw>
References: <1409558924.8085.46.camel@rzhang1-toshiba>
In-Reply-To: <1409558924.8085.46.camel@rzhang1-toshiba>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.71.143]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Zhang Rui [mailto:rui.zhang@intel.com] 
> Sent: Monday, September 01, 2014 4:09 PM
[...]
> Hi, Hayes,
> 
> We got a regression report complaining that wakeup from Suspend to RAM
> crashes, please refer to
> https://bugzilla.kernel.org/show_bug.cgi?id=82741
> 
> and it seems that it is introduced by commit
> b51ecea852b712618796d9eab8428a7d5f1f106f.

I couldn't reproduce the issue on my PC.
It would be better if I could borrow the platform to debug.
 
Best Regards,
Hayes
