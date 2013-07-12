Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757886Ab3GLXOG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 19:14:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63975 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754563Ab3GLXOE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 19:14:04 -0400
Date: Fri, 12 Jul 2013 16:13:57 -0700 (PDT)
Message-Id: <20130712.161357.1592789294361087970.davem@redhat.com>
To: hayeswang@realtek.com
Cc: gregkh@linuxfoundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH net 1/2] usb/net/r8152: fix integer overflow in
 expression
From: David Miller <davem@redhat.com>
In-Reply-To: <1373617576-2272-1-git-send-email-hayeswang@realtek.com>
References: <1373617576-2272-1-git-send-email-hayeswang@realtek.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hayes Wang <hayeswang@realtek.com>
Date: Fri, 12 Jul 2013 16:26:15 +0800

> config: make ARCH=avr32 allyesconfig
> drivers/net/usb/r8152.c: In function 'rtl8152_start_xmit':
> drivers/net/usb/r8152.c:956: warning: integer overflow in expression
> 
>    955	memset(tx_desc, 0, sizeof(*tx_desc));
>  > 956	tx_desc->opts1 = cpu_to_le32((len & TX_LEN_MASK) | TX_FS | TX_LS);
>    957	tp->tx_skb = skb;
> 
> Signed-off-by: Hayes Wang <hayeswang@realtek.com>
> Spotted-by: kbuild test robot <fengguang.wu@intel.com>

Applied.
