Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423091Ab3FUDIp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 23:08:45 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:45796 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1422901Ab3FUDIo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 23:08:44 -0400
Message-ID: <1371784123.19215.10.camel@joe-AO722>
Subject: Re: [PATCH] MAINTAINERS: Remove Hans J. Koch entries
From: Joe Perches <joe@perches.com>
To: "Hans J. Koch" <hjk@hansjkoch.de>
Cc: Pavel Machek <pavel@ucw.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Michal Simek <monstr@monstr.eu>, linux-kernel@vger.kernel.org,
        lm-sensors@lm-sensors.org
Date: Thu, 20 Jun 2013 20:08:43 -0700
In-Reply-To: <20130621025031.GG4775@local>
References: <086bdaf83fe546bd3c7fe163e565a0887770770f.1369317710.git.michal.simek@xilinx.com>
	 <71c482e15ee32fa304db73b984f6d5a63441cd92.1369317710.git.michal.simek@xilinx.com>
	 <51A5E644.1040901@monstr.eu> <51AC8D43.100@monstr.eu>
	 <20130603210513.GA22606@kroah.com>
	 <20130620160126.GB22115@amd.pavel.ucw.cz>
	 <1371745227.2146.13.camel@joe-AO722> <20130621025031.GG4775@local>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-06-21 at 04:50 +0200, Hans J. Koch wrote:
> Does each little driver really need a MAINTAINERS entry?

Hi Hans.

I think a lot of those driver MAINTAINERS entries are
maybe a little useful when the driver is just written
but are progressively less useful after a few months.

I once wrote a little script to look at whether or not
each listed maintainer had signed-off on a patch to
a listed file block for whatever time frame.

Most had not.

I'd rather people put their names in CREDITS than
MAINTAINERS if they want posterity entries.

> In my opinion, it should only be there if it is clear
> that it's not just a short project work.

I mostly agree with that, but sometimes it's useful
when the implementation is a bit complex and the
original author may still have some memory of the
complexity.

Anyway, I'm not resubmitting that patch.  If you want
to remove yourself from whatever entry, please do.

