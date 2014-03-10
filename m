Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753153AbaCJDpW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2014 23:45:22 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:46077 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752771AbaCJDpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2014 23:45:20 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.39 with qID s2A3jBhg012194, This message is accepted by code: ctloc85258
From: hayeswang <hayeswang@realtek.com>
To: "'David Miller'" <davem@davemloft.net>
CC: <netdev@vger.kernel.org>, <nic_swsd@realtek.com>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>
References: <1393934464-23675-1-git-send-email-hayeswang@realtek.com><1394161480-2918-1-git-send-email-hayeswang@realtek.com> <20140307.162732.1801095905509663010.davem@davemloft.net>
Subject: RE: [PATCH net-next 0/7] r8152: tx/rx improvement
Date: Mon, 10 Mar 2014 11:45:17 +0800
Message-ID: <084C9B4FE3DD41A2B6FFAA2A62F30692@realtek.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
Thread-Index: Ac86TA+PNz+q57d/QYSIKUlQnJZgPABxp6Ig
In-Reply-To: <20140307.162732.1801095905509663010.davem@davemloft.net>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.6157
X-Originating-IP: [172.21.71.143]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 David Miller [mailto:davem@davemloft.net] 
> Sent: Saturday, March 08, 2014 5:28 AM
> To: hayeswang@realtek.com
> Cc: netdev@vger.kernel.org; nic_swsd@realtek.com; 
> linux-kernel@vger.kernel.org; linux-usb@vger.kernel.org
> Subject: Re: [PATCH net-next 0/7] r8152: tx/rx improvement
[...]
> Note that if you ever add ->ndo_poll_controller support to 
> this driver,
> you will have to revert your spin_lock_irq{save,restore}() changes to
> your ->ndo_start_xmit.
> 
> Because the transmit function can indeed be invoked from hard IRQ
> context once you support netpoll.

Thank you for your reminder. I would notice that.

