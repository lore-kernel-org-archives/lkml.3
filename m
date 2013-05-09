Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755982Ab3EICfJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 22:35:09 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:49983 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753353Ab3EICfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 22:35:08 -0400
X-AuditID: 9c93016f-b7ba0ae000004cc2-b4-518b0b574e77
From: "Jongsung Kim" <neidhard.kim@lge.com>
To: "'Sergei Shtylyov'" <sergei.shtylyov@cogentembedded.com>
Cc: <davem@davemloft.net>, <peppe.cavallaro@st.com>,
        <chohnstaedt@innominate.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <201305081910.27203.neidhard.kim@lge.com> <518A7284.4000504@cogentembedded.com>
In-Reply-To: <518A7284.4000504@cogentembedded.com>
Subject: RE: net: phy: realtek: add rtl8201f driver
Date: Thu, 9 May 2013 11:35:03 +0900
Organization: LG Electronics
Message-ID: <008d01ce4c5d$cfd36410$6f7a2c30$@lge.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQILzE7k3gwnUuinRntsvs0Ef4B24gGRQ1u7mHSWaQA=
Content-Language: ko
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sergei Shtylyov <sergei.shtylyov@cogentembedded.com> :
>     Removal of unused #define's is a matter of a separate cleanup patch...

Sorry. I won't touch them.

>> +static int rtl8201f_ack_interrupt(struct phy_device *phydev) {
>> +	int err;
>> +
>> +	err = phy_read(phydev, RTL8201F_ISR);
>
>    This could be an initializer and so make the function shorter.
>

Agreed. I just thought it's better to make it similar to the
rtl821x_ack_interrupt. Then, may I make shorter the rtl821x_ack_interrupt as
well as rtl8201f_ack_interrupt?

>
>     You haven't run this patch thru scripts/checkpatch.pl -- there should
be a space between *if* and (.
>

Sorry.. what a mistake..


