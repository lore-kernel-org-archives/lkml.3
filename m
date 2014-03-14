Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755325AbaCNChd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 22:37:33 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:58241 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755200AbaCNCh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 22:37:29 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.39 with qID s2E2bG7c001670, This message is accepted by code: ctloc85258
From: hayeswang <hayeswang@realtek.com>
To: "'David Miller'" <davem@davemloft.net>, <David.Laight@ACULAB.COM>
CC: <netdev@vger.kernel.org>, <nic_swsd@realtek.com>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>
References: <1394712342-15778-1-Taiwan-albertk@realtek.com><1394712342-15778-2-Taiwan-albertk@realtek.com><063D6719AE5E284EB5DD2968C1650D6D0F6DCB6E@AcuExch.aculab.com> <20140313.132222.536931544768069240.davem@davemloft.net>
Subject: RE: [PATCH net-next v3 1/2] r8152: addRTL8152_EARLY_AGG_TIMEOUT_SUPER
Date: Fri, 14 Mar 2014 10:37:21 +0800
Message-ID: <A56A13416A724183888BB62CEFD2B817@realtek.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
Thread-Index: Ac8+4M9ipK+GKD0wSN2ww0vIetg71QATCUkg
In-Reply-To: <20140313.132222.536931544768069240.davem@davemloft.net>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.6157
X-Originating-IP: [172.21.71.143]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 From: David Miller [mailto:davem@davemloft.net] 
 Sent: Friday, March 14, 2014 1:22 AM
[...]
> And I fundamentally disagree with this being a Kconfig parameter.
> 
> Make it run-time calculated _or_ settable via ethtool.

Excuse me. How should I make it run-time calculated without a
Kconfig parameter? Should I use module_param? 

Best Regards,
Hayes

