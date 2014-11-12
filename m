Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753481AbaKLFnk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 00:43:40 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:37948 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753775AbaKLFnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 00:43:35 -0500
Date: Wed, 12 Nov 2014 00:43:31 -0500 (EST)
Message-Id: <20141112.004331.1112374574697663525.davem@davemloft.net>
To: hayeswang@realtek.com
Cc: netdev@vger.kernel.org, nic_swsd@realtek.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH net-next 2/2] r8152: adjust rtl_start_rx
From: David Miller <davem@davemloft.net>
In-Reply-To: <0835B3720019904CB8F7AA43166CEEB2ECE442@RTITMBSV03.realtek.com.tw>
References: <0835B3720019904CB8F7AA43166CEEB2ECE429@RTITMBSV03.realtek.com.tw>
	<20141112.001318.1905417679166281362.davem@davemloft.net>
	<0835B3720019904CB8F7AA43166CEEB2ECE442@RTITMBSV03.realtek.com.tw>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 11 Nov 2014 21:43:35 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hayes Wang <hayeswang@realtek.com>
Date: Wed, 12 Nov 2014 05:23:03 +0000

> David Miller [mailto:davem@davemloft.net] 
>> Sent: Wednesday, November 12, 2014 1:13 PM
> [...]
>> I really want to know why you are spending so much effort on this.
>> 
>> Is there a real situation that happened very often, which you
>> diagnosed in detail, and therefore you want to address?
> 
> No. I just consider the possible situation and want to
> make the driver better. If you think this is unnecessary,
> I would remove it.

What do other USB network drivers do in similar situations?
