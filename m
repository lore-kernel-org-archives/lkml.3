Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751909Ab3LORzH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Dec 2013 12:55:07 -0500
Received: from h1446028.stratoserver.net ([85.214.92.142]:34182 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751618Ab3LORzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Dec 2013 12:55:05 -0500
Message-ID: <52ADECDC.8000907@ahsoftware.de>
Date: Sun, 15 Dec 2013 18:54:36 +0100
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Gianluca Anzolin <gianluca@sottospazio.it>,
        Peter Hurley <peter@hurleysoftware.com>
CC: marcel@holtmann.org, Gustavo Padovan <gustavo@padovan.org>,
        linux-bluetooth@vger.kernel.org, gregkh@linuxfoundation.org,
        jslaby@suse.cz, linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION] rfcomm (userland) broken by commit 29cd718b
References: <1377620926-23370-1-git-send-email-gianluca@sottospazio.it> <20130919162413.GG4006@joana> <52AA1854.500@ahsoftware.de> <52AA1E62.1030109@hurleysoftware.com> <52AA483E.4080706@ahsoftware.de> <20131215112413.GA8980@sottospazio.it> <52ADB6B7.5010503@hurleysoftware.com> <20131215150847.GA10288@sottospazio.it>
In-Reply-To: <20131215150847.GA10288@sottospazio.it>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 15.12.2013 16:08, schrieb Gianluca Anzolin:

> The attached patch fixes the regression by releasing the tty_port in the
> shutdown method(). This way we can avoid strange games in the dlc callback
> where we are constrained by the dlc lock.

Yes, it fixes the problem here too.

> If this kind of approach is acceptable I will submit the patch for inclusion in
> a separate email.

If you do so, please add a Cc: stable@vger.kernel.org so that at least 
3.12 will have a working rfcomm. You might also add a Reported-by: 
and/or Tested-by: <holler@ahsoftware.de> if that makes someone happy ;)

I've missed this patch previously, because it came late and I was happy 
with the series of patches you've already had done.

Thanks a lot (for the previous series too).

Regards,

Alexander Holler
