Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754767Ab3BDMsd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 07:48:33 -0500
Received: from asix.com.tw ([210.243.224.51]:63121 "EHLO asix.com.tw"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754433Ab3BDMsb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 07:48:31 -0500
From: "Freddy" <freddy@asix.com.tw>
To: "'Daniel J Blueman'" <daniel@quora.org>
Cc: "'Linux Kernel'" <linux-kernel@vger.kernel.org>
References: <CAMVG2suXHz2ZhikrTa0j3gFc+_c7rdu0qFrXD3sve9JwfyzFAQ@mail.gmail.com>
In-Reply-To: <CAMVG2suXHz2ZhikrTa0j3gFc+_c7rdu0qFrXD3sve9JwfyzFAQ@mail.gmail.com>
Subject: RE: [PATCH, resubmit] ax88179_178a: ASIX AX88179_178A USB 3.0/2.0 to gigabit ethernet adapter driver
Date: Wed, 4 Dec 2013 20:48:24 +0800
Message-ID: <002901cef0ef$1f4a0e00$5dde2a00$@asix.com.tw>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQHKWZaTfbymrurcvG6QlDIOeXD7gZpNJB7Q
Content-Language: zh-tw
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



-----Original Message-----
From: Daniel J Blueman [mailto:daniel@quora.org] 
Sent: Sunday, February 03, 2013 10:22 PM
To: Freddy Xin
Cc: Linux Kernel
Subject: Re: [PATCH, resubmit] ax88179_178a: ASIX AX88179_178A USB 3.0/2.0
to gigabit ethernet adapter driver

> Hi Freddy,

> Michael, could you give me more information about how do you test this
driver?
> I have tried to reproduce the issue by using "ifconfig ethX mtu 1500", but
I didn't confront the same issue.
> Thank you in advance for your help.

> I found the same by just starting with 'ifconfig eth0 1500' and testing as
high as 4000; pinging another host with a large payload of size mtu-40
starts failing; after ~30s, I see the transmit time out trace [1].

> Of course, a default MTU size of 1500 is essential to avoid fragmentation
issues, so should be fixed too. Jumbo frames support is essential these days
too.

Hi Daniel,

The default MTU size will be change to 1500 and the HW jumbo frame function
will be enabled in the next submission of the driver.
Thanks for your help.

Freddy

