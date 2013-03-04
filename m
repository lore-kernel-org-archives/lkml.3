Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932709Ab3CDVxQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 16:53:16 -0500
Received: from mail-ee0-f49.google.com ([74.125.83.49]:40333 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932596Ab3CDVxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 16:53:14 -0500
MIME-Version: 1.0
In-Reply-To: <5134A37D.9000704@broadcom.com>
References: <1362401911-14074-1-git-send-email-akinobu.mita@gmail.com>
	<1362401911-14074-17-git-send-email-akinobu.mita@gmail.com>
	<5134A37D.9000704@broadcom.com>
Date: Tue, 5 Mar 2013 06:53:12 +0900
Message-ID: <CAC5umyjMvMW8ZZ1JFJcZVYo7PiUkG+dVgUNQ3bd87SW_6LnYqw@mail.gmail.com>
Subject: Re: [PATCH -v3 16/23] drivers/net: rename random32() to prandom_u32()
From: Akinobu Mita <akinobu.mita@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Michael Chan <mchan@broadcom.com>,
        Thomas Sailer <t.sailer@alumni.ethz.ch>,
        Jean-Paul Roubelat <jpr@f6fbb.org>, Bing Zhao <bzhao@marvell.com>,
        Brett Rudley <brudley@broadcom.com>,
        "Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
        Hante Meuleman <meuleman@broadcom.com>,
        brcm80211-dev-list@broadcom.com, netdev <netdev@vger.kernel.org>,
        linux-hams@vger.kernel.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/3/4 Arend van Spriel <arend@broadcom.com>
>>
>> @@ -1118,7 +1118,7 @@ static void brcmf_p2p_afx_handler(struct work_struct *work)
>>         if (afx_hdl->is_listen&&  afx_hdl->my_listen_chan)
>>
>>                 /* 100ms ~ 300ms */
>>                 err = brcmf_p2p_discover_listen(p2p, afx_hdl->my_listen_chan,
>> -                                               100 * (1 + (random32() % 3)));
>> +                                       100 * (1 + (prandom_u32() % 3)));
>
>
> Seems like indentation is wrong now. Please retain the alignment.

OK, I'll fix it.
