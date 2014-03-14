Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755512AbaCNHZN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 03:25:13 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:53356 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755133AbaCNHZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 03:25:11 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.39 with qID s2E7OoZY009826, This message is accepted by code: ctloc85258
From: hayeswang <hayeswang@realtek.com>
To: "'David Miller'" <davem@davemloft.net>
CC: <David.Laight@ACULAB.COM>, <netdev@vger.kernel.org>,
        <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>
References: <063D6719AE5E284EB5DD2968C1650D6D0F6DCB6E@AcuExch.aculab.com><20140313.132222.536931544768069240.davem@davemloft.net><A56A13416A724183888BB62CEFD2B817@realtek.com.tw> <20140314.000741.1829674011496195593.davem@davemloft.net>
Subject: RE: [PATCH net-next v3 1/2] r8152:addRTL8152_EARLY_AGG_TIMEOUT_SUPER
Date: Fri, 14 Mar 2014 15:24:50 +0800
Message-ID: <CE95F5CF3B924F0A921DDC3493A67365@realtek.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
Thread-Index: Ac8/OvUcm1JKJoEyS0OVubcXnN557gAEsI/Q
In-Reply-To: <20140314.000741.1829674011496195593.davem@davemloft.net>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.6157
X-Originating-IP: [172.21.71.143]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 From: David Miller [mailto:davem@davemloft.net] 
 Sent: Friday, March 14, 2014 12:08 PM
[...]
> >> And I fundamentally disagree with this being a Kconfig parameter.
> >> 
> >> Make it run-time calculated _or_ settable via ethtool.
> > 
> > Excuse me. How should I make it run-time calculated without a
> > Kconfig parameter? Should I use module_param? 
> 
> You run-time determine the setting based upon the negotiated link
> speed and traffic patterns.

It is difficult to design a algorithm which considers the hardware
of the platform, network traffic, and even the USB behavior to
dynamically modify the setting. I don't think I have the capability
to do it.

Besides, I don't wish to modify the setting by ethtool when re-loading
the driver or rebooting every time.

Excuse me. Why is it not accepted for being a Kconfig parameter.
It let the manufactuers of some platforms, especially the embedded
system, could tune their performance. Should I give up this patch?

