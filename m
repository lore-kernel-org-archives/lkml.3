Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751549AbaAGMgb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 07:36:31 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:34479 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750865AbaAGMgV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 07:36:21 -0500
X-SpamFilter-By: BOX Solutions SpamTrap 5.39 with qID s07CZnOM003985, This message is accepted by code: ctloc85258
From: hayeswang <hayeswang@realtek.com>
To: "=?iso-8859-1?Q?'Bj=F8rn_Mork'?=" <bjorn@mork.no>
CC: <oliver@neukum.org>, <netdev@vger.kernel.org>,
        "'nic_swsd'" <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>
References: <1388632963-1341-1-git-send-email-hayeswang@realtek.com><1388633110-1435-1-git-send-email-hayeswang@realtek.com><877gai8nqu.fsf@nemi.mork.no><605671F106F540BA9665A195CACB78A0@realtek.com.tw><8738l58pyd.fsf@nemi.mork.no><AA7EB9EA13B74B14BBE08C4278F7948C@realtek.com.tw> <87eh4l31or.fsf@nemi.mork.no>
Subject: RE: [PATCH net-next v2 6/6] r8152: support RTL8153
Date: Tue, 7 Jan 2014 20:35:54 +0800
Message-ID: <749DBDC9792E47BBA5884BEC7CF2D639@realtek.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
X-Mailer: Microsoft Office Outlook 11
Thread-Index: Ac8KwPIMPQNmwEAOQHWhp7zV8lKwqQA4xTqw
In-Reply-To: <87eh4l31or.fsf@nemi.mork.no>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.6157
X-Originating-IP: [172.21.71.143]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Bjørn Mork [mailto:bjorn@mork.no] 
> Sent: Monday, January 06, 2014 5:22 PM
> To: Hayeswang
> Cc: oliver@neukum.org; netdev@vger.kernel.org; nic_swsd; 
> linux-kernel@vger.kernel.org; linux-usb@vger.kernel.org
> Subject: Re: [PATCH net-next v2 6/6] r8152: support RTL8153
[...]
> Exactly the same device, but now cfg #1 is active and a 
> different set of
> drivers have bound to the interfaces.  This is possible 
> because none of
> the involved drivers disable the support for this device at 
> build-time.
> Instead they use the available interface descriptors for matching and
> probing supported functions.
> 
> End users will of course normally not go around writing stuff to sysfs
> attributes like this.  Creating an udev rule to select a specific
> counfiguration when the device is plugged is more useful for normal
> usage.

Thanks for your answer. I would study udev rule first.
Does the udev alwayes exist for all Linux system, such as
Android, embedded system, and so on?
 
Best Regards,
Hayes

