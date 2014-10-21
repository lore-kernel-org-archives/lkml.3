Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755532AbaJUSa4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 14:30:56 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:48414 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754990AbaJUSax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 14:30:53 -0400
X-Google-Original-Sender: <johan@hovold.com>
Date: Tue, 21 Oct 2014 20:27:50 +0200
From: Johan Hovold <johan@kernel.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Johan Hovold <johan@kernel.org>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, Alan Cox <gnomes@lxorguk.ukuu.org.uk>,
        Alexander Graf <agraf@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Heiko Stuebner <heiko@sntech.de>, Lee Jones <lee.jones@linaro.org>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Philippe =?iso-8859-1?Q?R=E9tornaz?= 
	<philippe.retornaz@gmail.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Romain Perier <romain.perier@gmail.com>
Subject: Re: [PATCH v2 01/47] kernel: Add support for poweroff handler call
 chain
Message-ID: <20141021182750.GC2113@localhost>
References: <1413864783-3271-1-git-send-email-linux@roeck-us.net>
 <1413864783-3271-2-git-send-email-linux@roeck-us.net>
 <20141021093405.GA2113@localhost>
 <20141021155047.GA3453@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141021155047.GA3453@roeck-us.net>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2014 at 08:50:47AM -0700, Guenter Roeck wrote:
> On Tue, Oct 21, 2014 at 11:34:05AM +0200, Johan Hovold wrote:
> > On Mon, Oct 20, 2014 at 09:12:17PM -0700, Guenter Roeck wrote:
> > 
> > > v2:
> > > - poweroff -> power_off
> > 
> > Do you want to stick to power[-_ ]off consistently throughout?
> > 
> 
> The string "poweroff" is used 819 times in today's upstream kernel.
> "power_off" is used 1,496 times, presumably mostly in variable names.
> "power-off" is used 145 times.
> 
> So, yes, I can change all newly introduced variable and function names
> from poweroff to power_off, and all newly introduced descriptive text
> from poweroff to power-off if that makes you happy. It won't improve
> consistency, though, since many of the current poweroff functions
> are named "something_poweroff". Hope you don't expect me to change
> all those function names as well.

Consistency is always nice, even if it's just within the files and
infrastructure you're adding.

But as already mentioned, the most important thing is that the interface
is consistent (e.g. function and constant names).

Johan
