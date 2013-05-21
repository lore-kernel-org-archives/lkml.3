Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758614Ab3EUBkD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 21:40:03 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:55533 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755663Ab3EUBjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 21:39:49 -0400
X-AuditID: 9c93017d-b7b64ae000000e51-a4-519ad063a4ba
From: "Jongsung Kim" <neidhard.kim@lge.com>
To: "'Stephen Warren'" <swarren@wwwdotorg.org>
Cc: "'Russell King'" <linux@arm.linux.org.uk>,
        "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>, <jslaby@suse.cz>,
        <linux-serial@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-rpi-kernel@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>
References: <007301ce375e$bcf6d6b0$36e48410$@lge.com> <5191D200.3040604@wwwdotorg.org> <01fd01ce5072$d6b9fcd0$842df670$@lge.com> <5192A692.4010700@wwwdotorg.org> <022d01ce5107$8bc668e0$a3533aa0$@lge.com> <5193164E.6050400@wwwdotorg.org> 
In-Reply-To: 
Subject: RE: [PATCH] ARM: PL011: add support for extended FIFO-size of PL011-r1p5
Date: Tue, 21 May 2013 10:39:46 +0900
Organization: LG Electronics
Message-ID: <007001ce55c4$139f96e0$3adec4a0$@lge.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQHInDuhqkp37yHuVjCbmrHEKQdwAwJ2699/Ap2LRfIByYWvJQG2+hs8Ak2PXv+YvCBWwIAHEKrw
Content-Language: ko
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jongsung Kim <neidhard.kim@lge.com> :
> Stephen Warren <swarren@wwwdotorg.org> :
>>> All r1p5 have 32-byte FIFO depth and it's not configurable. From the 
>>> PL011
>>> TRM:
>>> 
>>> r1p4-r1p5	Contains the following differences in functionality:
>>> 		* The receive and transmit FIFOs are increased to a depth of
32.
>>> 		* The Revision field in the UARTPeriphID2 Register on page
3-24
>>> 		  bits [7:4] now reads back as 0x3.
>>
>> Well, that certainly isn't true in practice. I think we should revert 
>> this commit until we can determine what the problem is.
>
> I asked to the ARM support about this. Waiting for reply..

ARM support said they doesn't have information about BCM2835 UART. Does
anyone have a communication channel to Broadcom? It takes time for me to
get contact point to Broadcom.. (I'm trying)

However, ARM support also said:

"If the Broadcom part definitely has 16-deep FIFOs, it cannot be based
on a PL011 r1p5, so I might guess that Broadcom have just referenced
the latest version of the documentation on our website, but have actually
implemented an earlier version."

