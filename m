Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753843Ab3EJDoq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 23:44:46 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:61787 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753548Ab3EJDop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 23:44:45 -0400
X-AuditID: 9c93016f-b7ba0ae000004cc2-c1-518c6d2bd61b
From: "Jongsung Kim" <neidhard.kim@lge.com>
To: "'Sergei Shtylyov'" <sergei.shtylyov@cogentembedded.com>
Cc: <davem@davemloft.net>, <peppe.cavallaro@st.com>,
        <chohnstaedt@innominate.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <201305081910.27203.neidhard.kim@lge.com> <518A7284.4000504@cogentembedded.com> <008d01ce4c5d$cfd36410$6f7a2c30$@lge.com> <518BD5CF.8040502@cogentembedded.com>
In-Reply-To: <518BD5CF.8040502@cogentembedded.com>
Subject: RE: net: phy: realtek: add rtl8201f driver
Date: Fri, 10 May 2013 12:44:42 +0900
Organization: LG Electronics
Message-ID: <010f01ce4d30$b500caa0$1f025fe0$@lge.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQILzE7k3gwnUuinRntsvs0Ef4B24gGRQ1u7AhpgkfoA99lprZhdqXyw
Content-Language: ko
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sergei Shtylyov <sergei.shtylyov@cogentembedded.com> :
>> Agreed. I just thought it's better to make it similar to the 
>> rtl821x_ack_interrupt.
>
>    Ah, then you may leave this code as is.
>
>> Then, may I make shorter the rtl821x_ack_interrupt as well as 
>> rtl8201f_ack_interrupt?
>
>    In a separate patch, if you wish.
>

Thank you for your comment.

