Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932109Ab3KVPUT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 10:20:19 -0500
Received: from mail-ie0-f169.google.com ([209.85.223.169]:54291 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932080Ab3KVPUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 10:20:18 -0500
MIME-Version: 1.0
In-Reply-To: <1385132242-3204-2-git-send-email-jonas.jensen@gmail.com>
References: <1385132242-3204-1-git-send-email-jonas.jensen@gmail.com>
	<1385132242-3204-2-git-send-email-jonas.jensen@gmail.com>
Date: Fri, 22 Nov 2013 16:20:17 +0100
Message-ID: <CACmBeS3vyLT7MYeTM6OzYvpWdqJgHp=ys0acf-qun14pbc=oXQ@mail.gmail.com>
Subject: Re: [PATCH 2/5] net: MOXA ART: connect to PHY and add ethtool support
From: Jonas Jensen <jonas.jensen@gmail.com>
To: netdev <netdev@vger.kernel.org>
Cc: davem <davem@davemloft.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jonas Jensen <jonas.jensen@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22 November 2013 15:57, Jonas Jensen <jonas.jensen@gmail.com> wrote:
>  drivers/net/ethernet/moxa/moxart_ether.c | 179 ++++++++++++++++++++++++++++++-
>  drivers/net/ethernet/moxa/moxart_ether.h |   1 +
>  2 files changed, 179 insertions(+), 1 deletion(-)

I see now I forgot to include the devicetree binding document.

I'll wait for comments.


Thanks,
Jonas
