Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752571AbaAQJYw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 04:24:52 -0500
Received: from mail-oa0-f51.google.com ([209.85.219.51]:34277 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752352AbaAQJYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 04:24:45 -0500
MIME-Version: 1.0
In-Reply-To: <20140116181520.GL17314@sirena.org.uk>
References: <1389848602-30985-1-git-send-email-tushar.behera@linaro.org>
	<20140116161841.GA7476@kroah.com>
	<20140116170814.GI17314@sirena.org.uk>
	<20140116172240.GB9587@kroah.com>
	<20140116181520.GL17314@sirena.org.uk>
Date: Fri, 17 Jan 2014 14:54:45 +0530
Message-ID: <CAHbNUh0dV_MWCUh=6yYQ3FzV69O3=j4QpMFsnjxTqJphSyHzXA@mail.gmail.com>
Subject: Re: [PATCH] tty: Fallback to use dynamic major number
From: Tushar Behera <tushar.behera@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>, lkml <linux-kernel@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        jslaby <jslaby@suse.cz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16 January 2014 23:45, Mark Brown <broonie@kernel.org> wrote:
> On Thu, Jan 16, 2014 at 09:22:40AM -0800, Greg KH wrote:
>> On Thu, Jan 16, 2014 at 05:08:14PM +0000, Mark Brown wrote:
>
>> > No, the issue is happening because the drivers are registering things
>> > at module load time and not at device instantiation time.
>
>> That's a driver bug that could easily be fixed, instead of hacking up
>> the tty core :)
>
> Looking at the code it really, really looked intentional - in any case
> that seems worthwhile, Tushar this looks like a way forwards?
>

Ok. I will prepare a patch with this approach for amba-pl011 and
samsung-uart drivers. If that works well, I will extend that to other
serial drivers.

Thanks to both of you for your time.
-- 
Tushar Behera
