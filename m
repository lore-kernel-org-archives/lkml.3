Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752969AbaCJIiz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 04:38:55 -0400
Received: from vserver.eikelenboom.it ([84.200.39.61]:40637 "EHLO
	smtp.eikelenboom.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752762AbaCJIiy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 04:38:54 -0400
Date: Mon, 10 Mar 2014 09:38:43 +0100
From: Sander Eikelenboom <linux@eikelenboom.it>
Organization: Eikelenboom IT services
X-Priority: 3 (Normal)
Message-ID: <1295963563.20140310093843@eikelenboom.it>
To: Sander Eikelenboom <linux@eikelenboom.it>,
        Marcel Holtmann <marcel@holtmann.org>,
        "Gustavo F. Padovan" <gustavo@padovan.org>,
        Peter Hurley <peter@hurleysoftware.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
CC: "bluez mailin list (linux-bluetooth@vger.kernel.org)" 
	<linux-bluetooth@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [RC6 Bell Chime] Re: [PATCH 00/24] rfcomm fixes
In-Reply-To: <1335661753.20140303203853@eikelenboom.it>
References: <1391997564-1805-1-git-send-email-peter@hurleysoftware.com> <3E0F3723-029F-4B12-8D77-9790FDBD3227@holtmann.org> <1259174563.20140212120644@eikelenboom.it> <1335661753.20140303203853@eikelenboom.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Since:
- 3.14-RC6 has been cut
- this regression is known and reported since the merge window
- the fix (revert of 3 patches) is known for over a month now
- but it's still not in mainline
- my polite ping request from last week seems to have provoked exactly 0 (zero) response.

IT'S TIME TO CHIME SOME BELLS :-)

Hope that WILL be heard somewhere ...

--
Sander

PS. on the informative side the 3 commits to be reverted are:

f86772af6a0f643d3e13eb3f4f9213ae0c333ee4 Bluetooth: Remove rfcomm_carrier_raised()
4a2fb3ecc7467c775b154813861f25a0ddc11aa0 Bluetooth: Always wait for a connection on RFCOMM open()
e228b63390536f5b737056059a9a04ea016b1abf Bluetooth: Move rfcomm_get_device() before rfcomm_dev_activate()


Monday, March 3, 2014, 8:38:53 PM, you wrote:


> Wednesday, February 12, 2014, 12:06:44 PM, you wrote:

>> Monday, February 10, 2014, 11:09:38 PM, you wrote:

>>> Hi Peter,

>>>> This patch series addresses a number of previously unknown issues
>>>> with the RFCOMM tty device implementation, in addition to
>>>> addressing the locking regression recently reported [1].
>>>> 
>>>> As Gianluca suggested and I agree, this series first reverts
>>>> 3 of the 4 patches of 3.14-rc1 for bluetooth/rfcomm/tty.c.

>>> so for 3.14 we should revert 3 patches. And then the other 21 are intended for 3.15 merge window.

>>> I realize that we still have to deal with some breakage, but we do not want regressions and I clearly not going to take 24 patches for 3.14 at this point in time.

>>> What I can do is take all 24 patches into bluetooth-next and let them sit for 1 week and have people test them. And then we go ahead with reverting 3 patches from 3.14. Does that make sense?

>> Reverting those 3 patches works for me.

>> --
>> Sander

>>> Regards

>>> Marcel

> Hi Marcel,

> Ping... it seems these 3 reverts are still not in 3.14-rc5 to fix the regressions ?

> --
> Sander



-- 
Best regards,
 Sander                            mailto:linux@eikelenboom.it

