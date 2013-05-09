Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751802Ab3EIQ7D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 12:59:03 -0400
Received: from mail-lb0-f172.google.com ([209.85.217.172]:40902 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134Ab3EIQ66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 12:58:58 -0400
Message-ID: <518BD5CF.8040502@cogentembedded.com>
Date: Thu, 09 May 2013 20:58:55 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Jongsung Kim <neidhard.kim@lge.com>
CC: davem@davemloft.net, peppe.cavallaro@st.com, chohnstaedt@innominate.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: net: phy: realtek: add rtl8201f driver
References: <201305081910.27203.neidhard.kim@lge.com> <518A7284.4000504@cogentembedded.com> <008d01ce4c5d$cfd36410$6f7a2c30$@lge.com>
In-Reply-To: <008d01ce4c5d$cfd36410$6f7a2c30$@lge.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 09-05-2013 6:35, Jongsung Kim wrote:

>>      Removal of unused #define's is a matter of a separate cleanup patch...

> Sorry. I won't touch them.

>>> +static int rtl8201f_ack_interrupt(struct phy_device *phydev) {
>>> +	int err;
>>> +
>>> +	err = phy_read(phydev, RTL8201F_ISR);

>>     This could be an initializer and so make the function shorter.

> Agreed. I just thought it's better to make it similar to the
> rtl821x_ack_interrupt.

    Ah, then you may leave this code as is.

> Then, may I make shorter the rtl821x_ack_interrupt as
> well as rtl8201f_ack_interrupt?

    In a separate patch, if you wish.

WBR, Sergei

