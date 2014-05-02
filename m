Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752964AbaEBUF0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 16:05:26 -0400
Received: from www84.your-server.de ([213.133.104.84]:39381 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752148AbaEBUFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 16:05:24 -0400
Message-ID: <1399061039.1910.4.camel@vger.seibold.net>
Subject: Re: X86: Impossible select Enhanced Real Time Clock Support (legacy
 PC RTC driver)
From: Stefani Seibold <stefani@seibold.net>
To: Alessandro Zummo <a.zummo@towertech.it>
Cc: John Stultz <john.stultz@linaro.org>, Randy Dunlap <rdunlap@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg KH <greg@kroah.com>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        Prarit Bhargava <prarit@redhat.com>
Date: Fri, 02 May 2014 22:03:59 +0200
In-Reply-To: <20140428202034.782de089@linux.lan.towertech.it>
References: <1397415946.1555.16.camel@vger.seibold.net>
	 <53555C56.1040900@infradead.org>
	 <CALAqxLVVGM2nON71BbhuD-7eXnqbKGomfL63COaT7nePuQQ=zg@mail.gmail.com>
	 <20140428202034.782de089@linux.lan.towertech.it>
Content-Type: text/plain; charset="us-ascii"
X-Mailer: Evolution 3.10.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-04-28 at 20:20 +0200, Alessandro Zummo wrote:
> On Mon, 28 Apr 2014 11:16:37 -0700
> John Stultz <john.stultz@linaro.org> wrote:
> 
> > >> This breaks the API since there is no more misc device /dev/rtc
> > >> available without a udev rule or a link to /dev/rtc0.  
> > 
> > So yea.. I feel like that /dev/rtcN renaming (and API) break (which
> > was a huge and annoying pain) was back in the 2.6.18-ish era?
> 
>  It's very old and linking/renaming is around since then.
> 
> > But it sounds like the driver/char/rtc bit is dead code, and needs a
> > cleanup? Or is there some use of that code that you need that the
> > generic RTC layer doesn't have?
> 

The driver/char/rtc is not working code and should be a wrapper to the
first rtc device.

>  as far as I know, no recent distribution is using the old code
>  anymore and the new (well, not so new anymore) framework provides the same functionality.
>  

Embedded distribution use it and depending on the /dev/rtc device. So
what is missing is the /dev/rtc misc device 10,135.

- Stefani

