Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755780Ab3KVVKG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 16:10:06 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:54419 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753277Ab3KVVKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 16:10:05 -0500
MIME-Version: 1.0
In-Reply-To: <CACmBeS3vyLT7MYeTM6OzYvpWdqJgHp=ys0acf-qun14pbc=oXQ@mail.gmail.com>
References: <1385132242-3204-1-git-send-email-jonas.jensen@gmail.com>
 <1385132242-3204-2-git-send-email-jonas.jensen@gmail.com> <CACmBeS3vyLT7MYeTM6OzYvpWdqJgHp=ys0acf-qun14pbc=oXQ@mail.gmail.com>
From: Florian Fainelli <f.fainelli@gmail.com>
Date: Fri, 22 Nov 2013 13:09:24 -0800
Message-ID: <CAGVrzcYC48enOr3nbXVVNQh0XzuDLu=hpAUqKHMEpABdiCYUAA@mail.gmail.com>
Subject: Re: [PATCH 2/5] net: MOXA ART: connect to PHY and add ethtool support
To: Jonas Jensen <jonas.jensen@gmail.com>
Cc: netdev <netdev@vger.kernel.org>, davem <davem@davemloft.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/11/22 Jonas Jensen <jonas.jensen@gmail.com>:
> On 22 November 2013 15:57, Jonas Jensen <jonas.jensen@gmail.com> wrote:
>>  drivers/net/ethernet/moxa/moxart_ether.c | 179 ++++++++++++++++++++++++++++++-
>>  drivers/net/ethernet/moxa/moxart_ether.h |   1 +
>>  2 files changed, 179 insertions(+), 1 deletion(-)
>
> I see now I forgot to include the devicetree binding document.
>
> I'll wait for comments.

You are doing two things in your patch, so that means two separate patches.
-- 
Florian
