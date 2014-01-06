Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752629AbaAFDVJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jan 2014 22:21:09 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:33968 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752569AbaAFDVE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jan 2014 22:21:04 -0500
X-SpamFilter-By: BOX Solutions SpamTrap 5.39 with qID s063Kbk1005511, This message is accepted by code: ctloc85258
From: hayeswang <hayeswang@realtek.com>
To: "=?iso-8859-1?Q?'Bj=F8rn_Mork'?=" <bjorn@mork.no>
CC: <oliver@neukum.org>, <netdev@vger.kernel.org>,
        "'nic_swsd'" <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>
References: <1388632963-1341-1-git-send-email-hayeswang@realtek.com><1388633110-1435-1-git-send-email-hayeswang@realtek.com><877gai8nqu.fsf@nemi.mork.no><605671F106F540BA9665A195CACB78A0@realtek.com.tw> <8738l58pyd.fsf@nemi.mork.no>
Subject: RE: [PATCH net-next v2 6/6] r8152: support RTL8153
Date: Mon, 6 Jan 2014 11:20:43 +0800
Message-ID: <AA7EB9EA13B74B14BBE08C4278F7948C@realtek.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
X-Mailer: Microsoft Office Outlook 11
Thread-Index: Ac8IZdjIJJZZyHxZTsOOFnQtX9eQIwCJyO0g
In-Reply-To: <8738l58pyd.fsf@nemi.mork.no>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.6157
X-Originating-IP: [172.21.71.143]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Bjørn Mork [mailto:bjorn@mork.no] 
[...]
> Sorry, but then this makes even less sense.  The active USB
> configuration is user selectable and you should make any of 
> them work if
> possible.  Why can't the drivers figure out this at runtime?

Excuse me. I have no idea about how to switch the configuration at
the runtime ,and how to change the default configuration when a
USB device is plugged. When a user select one of the configurations,
he/she would wish to fix the configuration number after rebooting or
after the dangle is unplugged and plugged again. For these reasons,
this is the simple way which I could think. Maybe I choose the wrong
method because I don't know how to satisfy the requests. May you
provide me the relative information? Then, I could replace the current
method. Thanks.
 
Best Regards,
Hayes

