Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757774Ab3BGCII (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 21:08:08 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:41480 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835Ab3BGCIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 21:08:06 -0500
X-SpamFilter-By: BOX Solutions SpamTrap 5.19 with qID r1727xjd019320, This message is released by code: ctlocs8528
From: hayeswang <hayeswang@realtek.com>
To: "'Francois Romieu'" <romieu@fr.zoreil.com>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <1360161987-3268-1-git-send-email-hayeswang@realtek.com> <1360161987-3268-3-git-send-email-hayeswang@realtek.com> <20130207000252.GB2784@electric-eye.fr.zoreil.com>
Subject: RE: [PATCH 3/5] r8169: Modify the method for setting firmware
Date: Thu, 7 Feb 2013 10:08:00 +0800
Message-ID: <69405959BD324BAC943970C031FD3D4B@realtek.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
Thread-Index: Ac4EyrwYXCaWM5HdR7+edmndit3bYQAC7Lkg
In-Reply-To: <20130207000252.GB2784@electric-eye.fr.zoreil.com>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.6157
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Francois Romieu [mailto:romieu@fr.zoreil.com] 
[...]
> 
> Did you check that none of rtl_nic/rtl8168d-{1, 2}.fw uses 
> PHY_READ_EFUSE ?
> 

I have made sure that none of the current firmwares use PHY_READ_EFUSE.
 
Best Regards,
Hayes

