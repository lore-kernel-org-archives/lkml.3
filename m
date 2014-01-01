Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755666AbaAAULP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jan 2014 15:11:15 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:59890 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754132AbaAAULL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jan 2014 15:11:11 -0500
Date: Wed, 1 Jan 2014 20:10:53 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Joe Xue <lgxue@hotmail.com>
Cc: "cooloney@gmail.com" <cooloney@gmail.com>,
        "rpurdie@rpsys.net" <rpurdie@rpsys.net>,
        "rob@landley.net" <rob@landley.net>,
        "milo.kim@ti.com" <milo.kim@ti.com>, "pavel@ucw.cz" <pavel@ucw.cz>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: Re: [PATCH] Add LED pattern trigger
Message-ID: <20140101201053.12be7d27@alan.etchedpixels.co.uk>
In-Reply-To: <BLU172-W451DF59115DB2B0A7F694AACC90@phx.gbl>
References: <1388362275-1618-1-git-send-email-lgxue@hotmail.com>
	<20131230162158.7420e811@alan.etchedpixels.co.uk>
	<BLU172-W451DF59115DB2B0A7F694AACC90@phx.gbl>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Dec 2013 13:48:50 -0500
Joe Xue <lgxue@hotmail.com> wrote:

> >> + * Based on Richard Purdie's ledtrig-timer.c and Atsushi Nemoto's
> >> + * ledtrig-heartbeat.c and Shuah Khan's ledtrig-transient.c
> >
> > I stil think this belongs in user space except for platforms with hardware
> > acceleration for it.
> 
> This can free the user space application from loop or thread.

Which is not a good reason for putting it in the kernel. I could make the
same argument for putting firefox in the kernel ...

> > This doesn't as far as I can see do what you think. If I have the file
> > currently open then device_remove_file will not remove my existing access
> > to it, but you just released the pattern data so I now write to free
> > memory.
> 
> will add the mutex lock to avoid that 		 	   		  

Ok
