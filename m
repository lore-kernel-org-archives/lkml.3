Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752561Ab3CEVnX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 16:43:23 -0500
Received: from mail-ee0-f45.google.com ([74.125.83.45]:43188 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354Ab3CEVnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 16:43:22 -0500
Message-ID: <513666F6.2000400@suse.cz>
Date: Tue, 05 Mar 2013 22:43:18 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:19.0) Gecko/20130124 Thunderbird/19.0
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Subject: Re: WARNING at tty_buffer.c:428 process_one_work()
References: <20130305.150338.470704111422696046.davem@davemloft.net> <5136554F.3060006@suse.cz> <20130305.153358.503062411029894196.davem@davemloft.net> <20130305.153450.1686180125402560098.davem@davemloft.net>
In-Reply-To: <20130305.153450.1686180125402560098.davem@davemloft.net>
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/05/2013 09:34 PM, David Miller wrote:
>> which via sunsab_console_setup()
>> invokes sunsab_startup() which requests the IRQ.

Of course I see now, I overlooked that invocation before.

> And let's be honest about the fact that it's very possible that you've
> overlooked many issues like this in the extremely large number of
> drivers that you made changes of this nature.

That is indeed possible; I don't have a solver in my head to prove
correctness (unfortunately). Now I'm going to revise the patches (and
send a fix for this one).

-- 
js
suse labs
