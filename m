Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756177Ab3EIC0a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 22:26:30 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:54989 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756004Ab3EIC0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 22:26:10 -0400
X-AuditID: 9c930197-b7c1fae000001854-12-518b093d189c
From: "Jongsung Kim" <neidhard.kim@lge.com>
To: "'Francois Romieu'" <romieu@fr.zoreil.com>
Cc: <davem@davemloft.net>, <peppe.cavallaro@st.com>,
        <chohnstaedt@innominate.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <201305081910.27203.neidhard.kim@lge.com> <20130508104119.GA24905@electric-eye.fr.zoreil.com>
In-Reply-To: <20130508104119.GA24905@electric-eye.fr.zoreil.com>
Subject: RE: net: phy: realtek: add rtl8201f driver
Date: Thu, 9 May 2013 11:26:05 +0900
Organization: LG Electronics
Message-ID: <008c01ce4c5c$8f572bc0$ae058340$@lge.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQILzE7k3gwnUuinRntsvs0Ef4B24gLKeYAqmGrJrEA=
Content-Language: ko
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Francois Romieu <romieu@fr.zoreil.com> :
> Your patch contains both "remove unused #define" and "support new
hardware"
> parts. I am not sure that the former is adequate for submission until
net-next opens.

I see. Sorry for trying touching them even without comment. I won't touch
them.

> static void rtl8201f_page_select(struct phy_device *phydev, int page) ?

Okay. Looks better..

>> +	if(phy_driver_register(&rtl8201f_driver) < 0)
>         ^^ -> missing space.

What a shame!

> You may use an array of phy_driver for realtek_{init/exit}

Agreed.

--
Ueimor

