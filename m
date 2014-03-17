Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756616AbaCQGDx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 02:03:53 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:36688 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754189AbaCQGDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 02:03:50 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.39 with qID s2H63YC1014249, This message is accepted by code: ctloc85258
From: hayeswang <hayeswang@realtek.com>
To: "'Francois Romieu'" <romieu@fr.zoreil.com>
CC: "'David Miller'" <davem@davemloft.net>, <David.Laight@ACULAB.COM>,
        <netdev@vger.kernel.org>, <nic_swsd@realtek.com>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>
References: <063D6719AE5E284EB5DD2968C1650D6D0F6DCB6E@AcuExch.aculab.com> <20140313.132222.536931544768069240.davem@davemloft.net> <A56A13416A724183888BB62CEFD2B817@realtek.com.tw> <20140314.000741.1829674011496195593.davem@davemloft.net> <CE95F5CF3B924F0A921DDC3493A67365@realtek.com.tw> <20140314234233.GA2341@electric-eye.fr.zoreil.com>
Subject: RE: [PATCH net-next v3 1/2] r8152:addRTL8152_EARLY_AGG_TIMEOUT_SUPER
Date: Mon, 17 Mar 2014 14:03:33 +0800
Message-ID: <4E261E0D59E54F2DA7F00A98B313B717@realtek.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: <20140314234233.GA2341@electric-eye.fr.zoreil.com>
Thread-Index: Ac8/3xiZ09FY0wXVSD+dnvhBCXilXwBxrCHg
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.6157
X-Originating-IP: [172.21.71.143]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 From: Francois Romieu [mailto:romieu@fr.zoreil.com] 
> Sent: Saturday, March 15, 2014 7:43 AM
[...]
> > Besides, I don't wish to modify the setting by ethtool when re-loading
> > the driver or rebooting every time.
> 
> Why ?
> 
> The recipe is different but there isn't much setup difference 
> between a module param and an ethtool command that is run through udev.
> The latter is more versatile though.

Thanks for your suggestion. I think I have to understand how to use them first.
 
Best Regards,
Hayes

