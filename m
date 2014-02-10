Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753200AbaBJWJo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 17:09:44 -0500
Received: from senator.holtmann.net ([87.106.208.187]:57011 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752111AbaBJWJn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 17:09:43 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 7.1 \(1827\))
Subject: Re: [PATCH 00/24] rfcomm fixes
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <1391997564-1805-1-git-send-email-peter@hurleysoftware.com>
Date: Mon, 10 Feb 2014 14:09:38 -0800
Cc: "Gustavo F. Padovan" <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Gianluca Anzolin <gianluca@sottospazio.it>,
        Alexander Holler <holler@ahsoftware.de>,
        Andrey Vihrov <andrey.vihrov@gmail.com>,
        Sander Eikelenboom <linux@eikelenboom.it>,
        "bluez mailin list (linux-bluetooth@vger.kernel.org)" 
	<linux-bluetooth@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <3E0F3723-029F-4B12-8D77-9790FDBD3227@holtmann.org>
References: <1391997564-1805-1-git-send-email-peter@hurleysoftware.com>
To: Peter Hurley <peter@hurleysoftware.com>
X-Mailer: Apple Mail (2.1827)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

> This patch series addresses a number of previously unknown issues
> with the RFCOMM tty device implementation, in addition to
> addressing the locking regression recently reported [1].
> 
> As Gianluca suggested and I agree, this series first reverts
> 3 of the 4 patches of 3.14-rc1 for bluetooth/rfcomm/tty.c.

so for 3.14 we should revert 3 patches. And then the other 21 are intended for 3.15 merge window.

I realize that we still have to deal with some breakage, but we do not want regressions and I clearly not going to take 24 patches for 3.14 at this point in time.

What I can do is take all 24 patches into bluetooth-next and let them sit for 1 week and have people test them. And then we go ahead with reverting 3 patches from 3.14. Does that make sense?

Regards

Marcel

