Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933125AbaD1V7M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 17:59:12 -0400
Received: from zabrina.hetzner-de.towertech.it ([178.63.16.19]:41109 "EHLO
	zabrina.hetzner-de.towertech.it" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932230AbaD1V7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 17:59:11 -0400
Date: Mon, 28 Apr 2014 20:20:34 +0200
From: Alessandro Zummo <a.zummo@towertech.it>
To: John Stultz <john.stultz@linaro.org>
Cc: Randy Dunlap <rdunlap@infradead.org>,
        Stefani Seibold <stefani@seibold.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg KH <greg@kroah.com>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        Prarit Bhargava <prarit@redhat.com>
Subject: Re: X86: Impossible select Enhanced Real Time Clock Support (legacy
 PC RTC driver)
Message-ID: <20140428202034.782de089@linux.lan.towertech.it>
In-Reply-To: <CALAqxLVVGM2nON71BbhuD-7eXnqbKGomfL63COaT7nePuQQ=zg@mail.gmail.com>
References: <1397415946.1555.16.camel@vger.seibold.net>
	<53555C56.1040900@infradead.org>
	<CALAqxLVVGM2nON71BbhuD-7eXnqbKGomfL63COaT7nePuQQ=zg@mail.gmail.com>
Organization: Tower Technologies
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Apr 2014 11:16:37 -0700
John Stultz <john.stultz@linaro.org> wrote:

> >> This breaks the API since there is no more misc device /dev/rtc
> >> available without a udev rule or a link to /dev/rtc0.  
> 
> So yea.. I feel like that /dev/rtcN renaming (and API) break (which
> was a huge and annoying pain) was back in the 2.6.18-ish era?

 It's very old and linking/renaming is around since then.

> But it sounds like the driver/char/rtc bit is dead code, and needs a
> cleanup? Or is there some use of that code that you need that the
> generic RTC layer doesn't have?

 as far as I know, no recent distribution is using the old code
 anymore and the new (well, not so new anymore) framework provides the same functionality.
 

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

