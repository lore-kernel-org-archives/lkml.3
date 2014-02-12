Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752265AbaBLLGx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 06:06:53 -0500
Received: from vserver.eikelenboom.it ([84.200.39.61]:49619 "EHLO
	smtp.eikelenboom.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397AbaBLLGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 06:06:50 -0500
Date: Wed, 12 Feb 2014 12:06:44 +0100
From: Sander Eikelenboom <linux@eikelenboom.it>
Organization: Eikelenboom IT services
X-Priority: 3 (Normal)
Message-ID: <1259174563.20140212120644@eikelenboom.it>
To: Marcel Holtmann <marcel@holtmann.org>
CC: Peter Hurley <peter@hurleysoftware.com>,
        "Gustavo F. Padovan" <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Gianluca Anzolin <gianluca@sottospazio.it>,
        Alexander Holler <holler@ahsoftware.de>,
        Andrey Vihrov <andrey.vihrov@gmail.com>,
        "bluez mailin list (linux-bluetooth@vger.kernel.org)" 
	<linux-bluetooth@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/24] rfcomm fixes
In-Reply-To: <3E0F3723-029F-4B12-8D77-9790FDBD3227@holtmann.org>
References: <1391997564-1805-1-git-send-email-peter@hurleysoftware.com> <3E0F3723-029F-4B12-8D77-9790FDBD3227@holtmann.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Monday, February 10, 2014, 11:09:38 PM, you wrote:

> Hi Peter,

>> This patch series addresses a number of previously unknown issues
>> with the RFCOMM tty device implementation, in addition to
>> addressing the locking regression recently reported [1].
>> 
>> As Gianluca suggested and I agree, this series first reverts
>> 3 of the 4 patches of 3.14-rc1 for bluetooth/rfcomm/tty.c.

> so for 3.14 we should revert 3 patches. And then the other 21 are intended for 3.15 merge window.

> I realize that we still have to deal with some breakage, but we do not want regressions and I clearly not going to take 24 patches for 3.14 at this point in time.

> What I can do is take all 24 patches into bluetooth-next and let them sit for 1 week and have people test them. And then we go ahead with reverting 3 patches from 3.14. Does that make sense?

Reverting those 3 patches works for me.

--
Sander

> Regards

> Marcel



