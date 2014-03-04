Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757489AbaCDPCf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 10:02:35 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:38578 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757243AbaCDPCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 10:02:33 -0500
Message-ID: <1393945351.26794.110.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: RE: [PATCH net-next 08/12] r8152: support TSO
From: Eric Dumazet <eric.dumazet@gmail.com>
To: David Laight <David.Laight@ACULAB.COM>
Cc: "'hayeswang'" <hayeswang@realtek.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "nic_swsd@realtek.com" <nic_swsd@realtek.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Date: Tue, 04 Mar 2014 07:02:31 -0800
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6D0F6D0284@AcuExch.aculab.com>
References: <1393934464-23675-1-git-send-email-hayeswang@realtek.com>
	 <1393934464-23675-9-git-send-email-hayeswang@realtek.com>
	 <063D6719AE5E284EB5DD2968C1650D6D0F6CFFE0@AcuExch.aculab.com>
	 <CF9EF717568D49DB858D5363B1099FC0@realtek.com.tw>
	 <063D6719AE5E284EB5DD2968C1650D6D0F6D0284@AcuExch.aculab.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-03-04 at 14:35 +0000, David Laight wrote:

> Does that mean you are splitting the 64k 'ethernet packet' from TCP
> is software? I've looked at the ax88179 where the hardware can do it.
> 
> Is there really a gain doing segmentation here if you have to do the
> extra data copy?

There is no 'extra' copy.

There is _already_ a copy, so what's the deal of doing this copy in a SG
enabled way ?



