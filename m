Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752891AbaBTVVK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 16:21:10 -0500
Received: from mail-oa0-f52.google.com ([209.85.219.52]:54337 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439AbaBTVVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 16:21:08 -0500
Message-ID: <530671BF.30909@lwfinger.net>
Date: Thu, 20 Feb 2014 15:21:03 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: linux-usb@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Warning from USC core on kernel 3.13
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan,

The Lenovo Yogi 13 tablet comes with a Realtek RTL8723AU wireless device built 
in. Realtek sent me a driver that I modified so that it would build on new 
kernels, and created a GitHub repo so that it would be available to the 
community. One of the users of this driver is reporting intermittent warnings 
that say

WARNING: CPU: 1 PID: 0 at drivers/usb/core/urb.c:452 usb_submit_urb+0x205/0x5d0()
usb 1-1.4: BOGUS urb xfer, pipe 3 != type 1

The full splat is available at http://pastebin.com/VcFPd4Yt.

As no other user has reported this problem, I think this is some kind of problem 
with the wireless device or the adapter on this box. Even so, I would like to 
know more about what is happening. In addition, Jes Sorensen at RedHat is 
working on making the driver suitable for submission to the staging part of the 
tree. Just in case other uses run into the problem, it would be good to know if 
a fix is possible.

Can you suggest any addition logging for when this situation occurs? The user is 
generating his own kernels, thus we can add any patches we want.

Thanks,

Larry
