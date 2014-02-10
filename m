Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753093AbaBJXAk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 18:00:40 -0500
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:46800 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752635AbaBJXAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 18:00:38 -0500
Message-ID: <52F95A10.5010507@hurleysoftware.com>
Date: Mon, 10 Feb 2014 18:00:32 -0500
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Marcel Holtmann <marcel@holtmann.org>
CC: "Gustavo F. Padovan" <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Gianluca Anzolin <gianluca@sottospazio.it>,
        Alexander Holler <holler@ahsoftware.de>,
        Andrey Vihrov <andrey.vihrov@gmail.com>,
        Sander Eikelenboom <linux@eikelenboom.it>,
        "bluez mailin list (linux-bluetooth@vger.kernel.org)" 
	<linux-bluetooth@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/24] rfcomm fixes
References: <1391997564-1805-1-git-send-email-peter@hurleysoftware.com> <3E0F3723-029F-4B12-8D77-9790FDBD3227@holtmann.org>
In-Reply-To: <3E0F3723-029F-4B12-8D77-9790FDBD3227@holtmann.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marcel,

On 02/10/2014 05:09 PM, Marcel Holtmann wrote:
> Hi Peter,
>
>> This patch series addresses a number of previously unknown issues
>> with the RFCOMM tty device implementation, in addition to
>> addressing the locking regression recently reported [1].
>>
>> As Gianluca suggested and I agree, this series first reverts
>> 3 of the 4 patches of 3.14-rc1 for bluetooth/rfcomm/tty.c.
>
> so for 3.14 we should revert 3 patches. And then the other 21 are
 > intended for 3.15 merge window.

Yep, this is probably best. At least 3.13 & 3.14 will behave the
same wrt rfcomm.

> I realize that we still have to deal with some breakage, but we
 > do not want regressions and I clearly not going to take 24 patches
 > for 3.14 at this point in time.

Yeah, I wasn't expecting you to.

> What I can do is take all 24 patches into bluetooth-next and let
 > them sit for 1 week and have people test them. And then we go ahead
 > with reverting 3 patches from 3.14. Does that make sense?

Yep, that's fine with me. Thanks.

Regards,
Peter Hurley
