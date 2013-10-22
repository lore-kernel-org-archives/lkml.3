Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755113Ab3JVToL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 15:44:11 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:59164 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754659Ab3JVToJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 15:44:09 -0400
Date: Tue, 22 Oct 2013 15:44:07 -0400 (EDT)
Message-Id: <20131022.154407.194174277374996701.davem@davemloft.net>
To: freddy@asix.com.tw
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, allan@asix.com.tw, louis@asix.com.tw
Subject: Re: [PATCH 1/2] [PATCH] ax88179_178a: Correct the RX error
 definition in RX header
From: David Miller <davem@davemloft.net>
In-Reply-To: <1382427131-2429-1-git-send-email-freddy@asix.com.tw>
References: <1382427131-2429-1-git-send-email-freddy@asix.com.tw>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Tue, 22 Oct 2013 12:44:09 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: freddy@asix.com.tw
Date: Tue, 22 Oct 2013 15:32:10 +0800

> From: Freddy Xin <freddy@asix.com.tw>
> 
> Correct the definition of AX_RXHDR_CRC_ERR and
> AX_RXHDR_DROP_ERR. They are BIT29 and BIT31 in pkt_hdr
> seperately.
> 
> Signed-off-by: Freddy Xin <freddy@asix.com.tw>

Applied.
