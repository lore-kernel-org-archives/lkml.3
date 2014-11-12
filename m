Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934196AbaKLCT4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 21:19:56 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:36377 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933914AbaKLCTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 21:19:53 -0500
Date: Tue, 11 Nov 2014 21:19:39 -0500 (EST)
Message-Id: <20141111.211939.1875418281655170486.davem@davemloft.net>
To: hayeswang@realtek.com
Cc: netdev@vger.kernel.org, nic_swsd@realtek.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH net-next 2/2] r8152: adjust rtl_start_rx
From: David Miller <davem@davemloft.net>
In-Reply-To: <0835B3720019904CB8F7AA43166CEEB2ECE337@RTITMBSV03.realtek.com.tw>
References: <1394712342-15778-90-Taiwan-albertk@realtek.com>
	<20141107.113522.837502028522211960.davem@davemloft.net>
	<0835B3720019904CB8F7AA43166CEEB2ECE337@RTITMBSV03.realtek.com.tw>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 11 Nov 2014 18:19:52 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hayes Wang <hayeswang@realtek.com>
Date: Wed, 12 Nov 2014 01:45:08 +0000

> David Miller [mailto:davem@davemloft.net] 
>> Sent: Saturday, November 08, 2014 12:35 AM
> [...]
>> Does this even work?
>> 
>> If you leave a hole in the ring, the device is going to stop there
>> anyways.
>> 
>> So better to replenish the next time you call into this function
>> rather than leaving gaps in your receive ring.
> 
> Excuse me. Is this still unacceptable?
> Should I remove this patch for keeping the original flow?

I haven't had time to process your original reply, please be patient.
