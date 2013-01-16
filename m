Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753653Ab3APNnl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 08:43:41 -0500
Received: from mail-ea0-f180.google.com ([209.85.215.180]:64157 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963Ab3APNnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 08:43:40 -0500
Message-ID: <50F6AD15.708@suse.cz>
Date: Wed, 16 Jan 2013 14:37:25 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:18.0) Gecko/20121129 Thunderbird/18.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: alan@linux.intel.com, jirislaby@gmail.com, linux-kernel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 00/10] TTY: switch flipping functions to tty_port
References: <1357224789-2853-1-git-send-email-jslaby@suse.cz> <20130116064735.GA7743@kroah.com>
In-Reply-To: <20130116064735.GA7743@kroah.com>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/16/2013 07:47 AM, Greg KH wrote:
> On Thu, Jan 03, 2013 at 03:53:00PM +0100, Jiri Slaby wrote:
>> In this series we get rid of the tty_port_tty_get in most hot paths as
>> all the flipping functions needs to know is in tty_port already. This
>> simplifies the code at some places a lot.
>>
>> Two fixes for coverity issues are included.
> 
> All applied, but the drivers/staging/sb105x/ driver is now broken, can
> you send me a follow-on patch to fix it?

I intentionally ignored that one as at the time of sending the patches,
it was marked as BROKEN in -next. It is still broken, since it does not
even have a tty_port for each port which is a requirement for a while
already. That is also a prerequisite to fix the build failure.

Steven, do you have any plans with the driver? What is its planned destiny?

thanks,
-- 
js
suse labs
