Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752532AbaKLFNW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 00:13:22 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:37737 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956AbaKLFNV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 00:13:21 -0500
Date: Wed, 12 Nov 2014 00:13:18 -0500 (EST)
Message-Id: <20141112.001318.1905417679166281362.davem@davemloft.net>
To: hayeswang@realtek.com
Cc: netdev@vger.kernel.org, nic_swsd@realtek.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH net-next 2/2] r8152: adjust rtl_start_rx
From: David Miller <davem@davemloft.net>
In-Reply-To: <0835B3720019904CB8F7AA43166CEEB2ECE429@RTITMBSV03.realtek.com.tw>
References: <0835B3720019904CB8F7AA43166CEEB2ECE0A3@RTITMBSV03.realtek.com.tw>
	<20141111.215056.2165761189796303933.davem@davemloft.net>
	<0835B3720019904CB8F7AA43166CEEB2ECE429@RTITMBSV03.realtek.com.tw>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 11 Nov 2014 21:13:20 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hayes Wang <hayeswang@realtek.com>
Date: Wed, 12 Nov 2014 05:07:40 +0000

> How about that when a error occurs, add the remaining rx
> to the list without submission? Then, the remianing rx
> could be re-submitted later, and the rtl_start_rx() could
> be completed as soon as possible.

I really want to know why you are spending so much effort on this.

Is there a real situation that happened very often, which you
diagnosed in detail, and therefore you want to address?
