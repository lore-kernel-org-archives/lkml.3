Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752703AbaKBWxX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2014 17:53:23 -0500
Received: from violet.fr.zoreil.com ([92.243.8.30]:39069 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751463AbaKBWxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2014 17:53:20 -0500
Date: Sun, 2 Nov 2014 23:53:07 +0100
From: Francois Romieu <romieu@fr.zoreil.com>
To: Hayes Wang <hayeswang@realtek.com>
Cc: David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        nic_swsd <nic_swsd@realtek.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: Re: [PATCH net-next v2 2/3] r8152: clear the flagofSCHEDULE_TASKLET
 in tasklet
Message-ID: <20141102225307.GA19900@electric-eye.fr.zoreil.com>
References: <1394712342-15778-75-Taiwan-albertk@realtek.com>
 <1394712342-15778-79-Taiwan-albertk@realtek.com>
 <1394712342-15778-81-Taiwan-albertk@realtek.com>
 <20141031.161520.3547230591227504.davem@davemloft.net>
 <0835B3720019904CB8F7AA43166CEEB2ECD8A7@RTITMBSV03.realtek.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0835B3720019904CB8F7AA43166CEEB2ECD8A7@RTITMBSV03.realtek.com.tw>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hayes Wang <hayeswang@realtek.com> :
>  David Miller [davem@davemloft.net]
[...]
> > If another thread of control sets the bit between the test and the
> > clear, you will lose an event.
> 
> It is fine. The flag is used to schedule a tasklet, so if the tasklet is
> starting running, all the other plans for scheduling a tasklet could
> be cleared.

test_and_clear_bit (dense) or clear_bit would be more idiomatic.

-- 
Ueimor
