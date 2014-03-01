Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250AbaCATFt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2014 14:05:49 -0500
Received: from mail.active-venture.com ([67.228.131.205]:57212 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753107AbaCATFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2014 14:05:47 -0500
X-Originating-IP: 108.223.40.66
Message-ID: <53122F89.70800@roeck-us.net>
Date: Sat, 01 Mar 2014 11:05:45 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Jiri Slaby <jslaby@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: Josh Boyer <jwboyer@fedoraproject.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, David Miller <davem@davemloft.net>
Subject: Re: 3.12-stable kernel tree being taken over by Jiri Slaby
References: <20140226231910.GA8789@kroah.com> <530FFC2C.5010305@roeck-us.net> <5311A858.9080204@suse.cz>
In-Reply-To: <5311A858.9080204@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi,
>
>> do you want me to keep running my build tests on the patch queue for 3.12 ?
>
> definitely yes, if you could.
>
>> If yes, I'll probably need to know the location of your (quilt ?)
>> repository
>> so I can import the patches, similar to what I do for 3.2 and the releases
>> managed by Greg.
>
> I've just published the stable-3.12-queue at:
> https://git.kernel.org/cgit/linux/kernel/git/jirislaby/linux-stable.git/log/?h=stable-3.12-queue
>
> aka
>
> git://git.kernel.org/pub/scm/linux/kernel/git/jirislaby/linux-stable.git#stable-3.12-queue
>

All set up and working as far as I can see.

Guenter

