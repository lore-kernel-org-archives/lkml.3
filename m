Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751539AbaHJMXX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2014 08:23:23 -0400
Received: from bart.luffy.cx ([78.47.78.131]:60911 "EHLO bart.luffy.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751400AbaHJMXW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2014 08:23:22 -0400
X-Greylist: delayed 434 seconds by postgrey-1.27 at vger.kernel.org; Sun, 10 Aug 2014 08:23:22 EDT
From: Vincent Bernat <vincent@bernat.im>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Eli Billauer <eli.billauer@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: xillybus: fix some coding style errors
References: <1405516782-11434-1-git-send-email-vincent@bernat.im>
	<20140810033413.GA20872@kroah.com>
Date: Sun, 10 Aug 2014 14:16:04 +0200
In-Reply-To: <20140810033413.GA20872@kroah.com> (Greg Kroah-Hartman's message
	of "Sat, 9 Aug 2014 20:34:13 -0700")
Message-ID: <m3y4uwsfp7.fsf@neo.luffy.cx>
User-Agent: Gnus/5.130012 (Ma Gnus v0.12) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 ❦  9 août 2014 20:34 -0700, Greg Kroah-Hartman <gregkh@linuxfoundation.org> :

>> This includes:
>>  - keep "else" on the same line as the closing brace
>>  - don't use "else" after "return"
>
>>  - don't issue a message for an out-of-memory error
>>  - blank line after a declaration
>> 
>> Signed-off-by: Vincent Bernat <vincent@bernat.im>
>> ---
>>  drivers/staging/xillybus/xillybus_core.c | 13 +++++--------
>>  1 file changed, 5 insertions(+), 8 deletions(-)
>
> This patch doesn't apply at all, as I think you made it against an old
> kernel tree :(

Hi Greg!

You already applied this patch. It is almost one month old. Dunno why
you received it a second time.
-- 
Make sure special cases are truly special.
            - The Elements of Programming Style (Kernighan & Plauger)
