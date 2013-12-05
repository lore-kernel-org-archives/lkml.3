Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933567Ab3LERl4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 12:41:56 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:50070 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932997Ab3LERly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 12:41:54 -0500
Message-ID: <52A0BADE.2030603@gmail.com>
Date: Thu, 05 Dec 2013 18:41:50 +0100
From: Harald Arnesen <skogtun.linux@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Pavel Machek <pavel@ucw.cz>
CC: Matthew Garrett <matthew.garrett@nebula.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Remove unnecessarily gendered language
References: <1386033532-25431-1-git-send-email-matthew.garrett@nebula.com>	<20131205104808.GA6455@amd.pavel.ucw.cz> <20131205165429.34468e1b@alan.etchedpixels.co.uk>
In-Reply-To: <20131205165429.34468e1b@alan.etchedpixels.co.uk>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One Thousand Gnomes [2013-12-05 17:54]:

>>> @@ -23,7 +24,7 @@ Quota netlink interface
>>>  When user exceeds a softlimit, runs out of grace time or reaches hardlimit,
>>>  quota subsystem traditionally printed a message to the controlling terminal of
>>>  the process which caused the excess. This method has the disadvantage that
>>> -when user is using a graphical desktop he usually cannot see the message.
>>> +when user is using a graphical desktop they usually cannot see the
>>>  message.

> I would argue that "This method has the disadvantage that when user
> is using a graphical desktop he usually cannot see the message." 

How about:

"This method has the disadvantage that, when using a graphical desktop,
the user usually cannot see the message" - or something similar? Gender
neutral, and not _too_ cumbersome, aside from the "user...usually".
-- 
Hilsen Harald
