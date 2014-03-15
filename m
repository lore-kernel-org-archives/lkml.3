Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756552AbaCONv7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2014 09:51:59 -0400
Received: from vserver.eikelenboom.it ([84.200.39.61]:50995 "EHLO
	smtp.eikelenboom.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755779AbaCONv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2014 09:51:57 -0400
Date: Sat, 15 Mar 2014 14:51:46 +0100
From: Sander Eikelenboom <linux@eikelenboom.it>
Organization: Eikelenboom IT services
X-Priority: 3 (Normal)
Message-ID: <164289036.20140315145146@eikelenboom.it>
To: Peter Hurley <peter@hurleysoftware.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        Marcel Holtmann <marcel@holtmann.org>,
        "Gustavo F. Padovan" <gustavo@padovan.org>,
        "bluez mailin list (linux-bluetooth@vger.kernel.org)" 
	<linux-bluetooth@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RC6 Bell Chime] [PATCH 00/24] rfcomm fixes
In-Reply-To: <53225B87.1030904@hurleysoftware.com>
References: <1391997564-1805-1-git-send-email-peter@hurleysoftware.com> <3E0F3723-029F-4B12-8D77-9790FDBD3227@holtmann.org> <1259174563.20140212120644@eikelenboom.it> <1335661753.20140303203853@eikelenboom.it> <1295963563.20140310093843@eikelenboom.it> <20140310150858.GA25703@tuxdriver.com> <EE67811F-FA2E-4773-8852-CB79BD7CDF1C@holtmann.org> <1679354302.20140314014901@eikelenboom.it> <53225B87.1030904@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Friday, March 14, 2014, 2:29:43 AM, you wrote:

> Hi Sander,

> On 03/13/2014 08:49 PM, Sander Eikelenboom wrote:
>> <sarcasm on>
>> Is it just me .. or is this going at the speed of about a bluetooth connection ..
>> and probably missing the boot for 3.14 ? (for no good reason IMHO)
>> <sarcasm off>
>>
>> (it was not in John's nor Dave's last pull request, although it seems to be reverted in the bluetooth tree now .. i didn't
>> see any formal pull request from that .. to get it even *starting* to traverse all the trees up to Linus ... )

> Known bugs sometimes roll out into mainline release because the
> alternative can be worse.

> As I explained in the follow-up to my patch series, I would
> not have expected Marcel to pick up any of the fixes for 3.14.
> There are a lot of moving parts in usb + bluetooth + rfcomm + tty,
> and the unfortunate reality is that -next doesn't get as much
> testing as it should.

> The fault is mine because Gianluca let me know about the
> problems with the conversion to tty_port, but the holidays really
> interfered with my ability to put this work first, and I'm sorry
> for that.

> I know the breakage around RFCOMM is frustrating but I think the
> worst is behind us. After 3.15 gets some -rc testing, I will
> be happy to cherry-pick the critical fixes for -stable inclusion.

Ok but the breakage/regression was known since around the merge window.
I thought the "standard policy" when things cause new regression and are not fixable (too intrusive, too time consuming you
name the reason), was to revert .. (and possibly ASAP so the reverts also get some test coverage in mainline RC's).
That's also why i tested the revert ASAP to let you know that that worked  .. at least for me.

But no big deal for mee .. the reverts are simple enough to be privately applied.

> Regards,
> Peter Hurley


