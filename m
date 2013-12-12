Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752036Ab3LLXgA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 18:36:00 -0500
Received: from h1446028.stratoserver.net ([85.214.92.142]:50742 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751794Ab3LLXf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 18:35:57 -0500
Message-ID: <52AA483E.4080706@ahsoftware.de>
Date: Fri, 13 Dec 2013 00:35:26 +0100
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131106 Thunderbird/17.0.9
MIME-Version: 1.0
To: Peter Hurley <peter@hurleysoftware.com>
CC: Gustavo Padovan <gustavo@padovan.org>,
        Gianluca Anzolin <gianluca@sottospazio.it>, marcel@holtmann.org,
        linux-bluetooth@vger.kernel.org, gregkh@linuxfoundation.org,
        jslaby@suse.cz, linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION] rfcomm (userland) broken by commit 29cd718b
References: <1377620926-23370-1-git-send-email-gianluca@sottospazio.it> <20130919162413.GG4006@joana> <52AA1854.500@ahsoftware.de> <52AA1E62.1030109@hurleysoftware.com>
In-Reply-To: <52AA1E62.1030109@hurleysoftware.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 12.12.2013 21:36, schrieb Peter Hurley:

>> What currently happens is that when one kills rfcomm (and any other
>> terminal which might use that tty), the entry in /dev doesn't
>> disappear. That means the same call to refcomm with the same device
>> (e.g. [/dev/]rfcomm1 doesn't work.
> 
> Thanks for the report, Alexander.
> 
> Point 4 above details a different situation; something else is
> happening.
> 
> Would you please detail the necessary steps to reproduce this regression?
> (How do you 'kill' rfcomm? etc.  Shell command lines would be best.)

Just call

rfcomm connect rfcomm9 01:23:45:67:89:ab

wait until the connection happened  (a message will appear) and then
press ctrl-c. This still terminates the bluetooth connection, but the
device in /dev is now left.

Regards,

Alexander Holler
