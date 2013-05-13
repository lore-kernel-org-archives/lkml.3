Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753875Ab3EMCsj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 May 2013 22:48:39 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:45587 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753318Ab3EMCsi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 May 2013 22:48:38 -0400
X-AuditID: 9c93016f-b7b9bae000002df2-8c-519054830610
From: "Jongsung Kim" <neidhard.kim@lge.com>
To: "'Sergei Shtylyov'" <sergei.shtylyov@cogentembedded.com>
Cc: <davem@davemloft.net>, <peppe.cavallaro@st.com>,
        <chohnstaedt@innominate.com>, <timur@freescale.com>,
        <heiko.carstens@de.ibm.com>, <schwidefsky@de.ibm.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <201305081910.27203.neidhard.kim@lge.com> <1368170967-20589-4-git-send-email-neidhard.kim@lge.com> <518CD784.1030709@cogentembedded.com>
In-Reply-To: <518CD784.1030709@cogentembedded.com>
Subject: RE: [PATCH v2 4/4] net: phy: realtek: cleanup code
Date: Mon, 13 May 2013 11:48:35 +0900
Organization: LG Electronics
Message-ID: <017801ce4f84$5d423320$17c69960$@lge.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQILzE7k3gwnUuinRntsvs0Ef4B24gJS35WgAU773/mYal2DkA==
Content-Language: ko
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sergei Shtylyov <sergei.shtylyov@cogentembedded.com> :
>> -		.suspend	= genphy_suspend,
>> -		.resume		= genphy_resume,
>> +		.suspend	= &genphy_suspend,
>> +		.resume		= &genphy_resume,
>
>    Contrariwise, you should have dropped & from the other functions. 
>It's completely superfluous.
>

Agreed. Thank you  for your comment, Sergei.

