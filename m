Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754862AbaCMSRz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 14:17:55 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:58658 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754719AbaCMSRy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 14:17:54 -0400
MIME-Version: 1.0
Date: Thu, 13 Mar 2014 11:17:53 -0700
Message-ID: <CAA344TGKAajYm5LxK4Cy=UUcErkaPCq9B=xpNLY5KuPws6p4Rw@mail.gmail.com>
Subject: TI wlxx driver, #define collision for 'QURIKS'
From: nat ersoz <natersoz@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings Linux Wifi developers, TI wlxxx specifically.

I noticed a symbol definitions 'collision' in the TI wl12xx device
driver source code.
My working kernel is 3.13.0-rc3, but this is true for 3.14.rc3 as well
as the wireless-next branch.
http://git.kernel.org/cgit/linux/kernel/git/linville/wireless-next.git/

These quirks and conditions may (likely it seems) conflict:

File: linux/include/wl12xx.h:
#define WL12XX_PLATFORM_QUIRK_EDGE_IRQ    BIT(0)

File: drivers/net/wireless/ti/wlcore/wlcore.h
#define WLCORE_QUIRK_END_OF_TRANSACTION        BIT(0)

I think this might be a problem in several scenarios. Thoughts?
Please CC me in replies. I am not subscribed to LKML.
If I'm wasting time or completely off base, please merely reply as
such and I will slink away.

Thanks,

Nat Ersoz
natersoz@gmail.com
425-417-5182 (cell)
