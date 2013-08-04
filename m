Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753856Ab3HDUGN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Aug 2013 16:06:13 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:35403 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753764Ab3HDUGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Aug 2013 16:06:10 -0400
Message-ID: <51FEB410.6080909@gmail.com>
Date: Sun, 04 Aug 2013 22:05:36 +0200
From: Yacine Belkadi <yacine.belkadi.1@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Alan Stern <stern@rowland.harvard.edu>, Jiri Kosina <jkosina@suse.cz>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Kevin Hilman <khilman@linaro.org>,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Thomas Renninger <trenn@suse.de>, Hannes Reinecke <hare@suse.de>,
        Lan Tianyu <tianyu.lan@intel.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Ming Lei <ming.lei@canonical.com>,
        =?UTF-8?B?VMO8bGluIMSwemVy?= <tulinizer@gmail.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Johan Hovold <jhovold@gmail.com>, Kay Sievers <kay@vrfy.org>,
        Julius Werner <jwerner@chromium.org>,
        Yuanhan Liu <yliu.null@gmail.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH] usb: fix some scripts/kernel-doc warnings
References: <1375467004-2623-1-git-send-email-yacine.belkadi.1@gmail.com> <20130803032908.GA10902@kroah.com>
In-Reply-To: <20130803032908.GA10902@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03/2013 05:29 AM, Greg Kroah-Hartman wrote:
> On Fri, Aug 02, 2013 at 08:10:04PM +0200, Yacine Belkadi wrote:
>> When building the htmldocs (in verbose mode), scripts/kernel-doc reports the
>> following type of warnings:
>>
>> Warning(drivers/usb/core/usb.c:76): No description found for return value of
>> 'usb_find_alt_setting'
>>
>> Fix them by:
>> - adding some missing descriptions of return values
>> - using "Return" sections for those descriptions
>>
>> Signed-off-by: Yacine Belkadi <yacine.belkadi.1@gmail.com>
>> ---
>>
>>  Applied to b3a3a9c441e2c8f6b6760de9331023a7906a4ac6
> 
> What does this line mean?

It's the commit on which I created and applied the patch:

commit b3a3a9c441e2c8f6b6760de9331023a7906a4ac6
Merge: a582e5f e70e78e
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon Jul 22 19:07:24 2013 -0700

    Merge tag 'trace-3.11-rc2' of
git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace

Yacine
