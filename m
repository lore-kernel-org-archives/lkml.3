Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754608AbaCNB3t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 21:29:49 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:35268 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752808AbaCNB3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 21:29:48 -0400
Message-ID: <53225B87.1030904@hurleysoftware.com>
Date: Thu, 13 Mar 2014 21:29:43 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Sander Eikelenboom <linux@eikelenboom.it>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        Marcel Holtmann <marcel@holtmann.org>,
        "Gustavo F. Padovan" <gustavo@padovan.org>,
        "bluez mailin list (linux-bluetooth@vger.kernel.org)" 
	<linux-bluetooth@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RC6 Bell Chime] [PATCH 00/24] rfcomm fixes
References: <1391997564-1805-1-git-send-email-peter@hurleysoftware.com> <3E0F3723-029F-4B12-8D77-9790FDBD3227@holtmann.org> <1259174563.20140212120644@eikelenboom.it> <1335661753.20140303203853@eikelenboom.it> <1295963563.20140310093843@eikelenboom.it> <20140310150858.GA25703@tuxdriver.com> <EE67811F-FA2E-4773-8852-CB79BD7CDF1C@holtmann.org> <1679354302.20140314014901@eikelenboom.it>
In-Reply-To: <1679354302.20140314014901@eikelenboom.it>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sander,

On 03/13/2014 08:49 PM, Sander Eikelenboom wrote:
> <sarcasm on>
> Is it just me .. or is this going at the speed of about a bluetooth connection ..
> and probably missing the boot for 3.14 ? (for no good reason IMHO)
> <sarcasm off>
>
> (it was not in John's nor Dave's last pull request, although it seems to be reverted in the bluetooth tree now .. i didn't
> see any formal pull request from that .. to get it even *starting* to traverse all the trees up to Linus ... )

Known bugs sometimes roll out into mainline release because the
alternative can be worse.

As I explained in the follow-up to my patch series, I would
not have expected Marcel to pick up any of the fixes for 3.14.
There are a lot of moving parts in usb + bluetooth + rfcomm + tty,
and the unfortunate reality is that -next doesn't get as much
testing as it should.

The fault is mine because Gianluca let me know about the
problems with the conversion to tty_port, but the holidays really
interfered with my ability to put this work first, and I'm sorry
for that.

I know the breakage around RFCOMM is frustrating but I think the
worst is behind us. After 3.15 gets some -rc testing, I will
be happy to cherry-pick the critical fixes for -stable inclusion.

Regards,
Peter Hurley
