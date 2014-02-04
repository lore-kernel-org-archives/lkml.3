Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753844AbaBDPmi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 10:42:38 -0500
Received: from mail-ob0-f172.google.com ([209.85.214.172]:57160 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066AbaBDPmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 10:42:35 -0500
Message-ID: <52F10A68.60606@lwfinger.net>
Date: Tue, 04 Feb 2014 09:42:32 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: andrea.merello@gmail.com, Dan Carpenter <dan.carpenter@oracle.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Stefan Lippers-Hollmann <s.L-H@gmx.de>, Dave Jones <davej@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Wireless List <linux-wireless@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Driver Project <devel@linuxdriverproject.org>
Subject: Re: rtl8821ae.
References: <52ee2ee736e00_2c3211fc86c5851f@209.249.196.67.mail> <20140202160512.GA4946@redhat.com> <201402021807.37772.s.L-H@gmx.de> <52EFCC66.9020304@lwfinger.net> <20140203201228.GE26722@mwanda> <CA+55aFyHZfw9rtZQJ9i2p7MQAVX4iM0QCdzRZzaivD2nRDHeLQ@mail.gmail.com> <CAN8YU5PJWqnaBN_oaZ-yZjV-s9oCkKPa4ebk-kNbhPSgpd3_wQ@mail.gmail.com> <20140204092836.GG26776@mwanda> <CAN8YU5PfJ2ijHzghJ-FJPYJeFwTfoGN-qpJ5R5ctYp3R1p13hA@mail.gmail.com>
In-Reply-To: <CAN8YU5PfJ2ijHzghJ-FJPYJeFwTfoGN-qpJ5R5ctYp3R1p13hA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/04/2014 08:41 AM, Andrea Merello wrote:
> Yes, I attach a cumulative patch for latest version of my work.
>
> When I will send this asking for merge in kernel, I will split it in
> some patches, because I also also included fix and improvements for
> other already supported cards (not directly related to rtl8187se
> support).
>
> About this, I will produce separate patches for rtl8180 driver if
> finally the drivers will be merged and also in case I'll split them..
>
> Any suggestion/advice will be appreciated :)
>
> Thanks
> Andrea
>
> On Tue, Feb 4, 2014 at 10:28 AM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
>> Nice.  Thanks for doing that.  Do you have some patches we could review
>> of the merged driver?

Andrea,

In the case of the RTL8187SE driver, you only have three chips to deal with, two 
of them are already in the driver, 802.11g devices are rather simple, and it is 
extremely unlikely that any new devices will be added. For those reasons, I 
think it is appropriate to make a combined driver. As there has been quite a bit 
of testing on the current version, my vote is to stay with it.

I will test the latest revision soon. I'm not sure my laptop will hibernate, but 
I will test that operation if I can.

Larry


