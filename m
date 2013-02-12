Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756402Ab3BLCyM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 21:54:12 -0500
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:42834 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751456Ab3BLCyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 21:54:10 -0500
Message-ID: <1360637638.4415.13.camel@thor.lan>
Subject: Re: WARNING: at drivers/tty/tty_buffer.c:476  (tty is NULL)
From: Peter Hurley <peter@hurleysoftware.com>
To: Michael Ellerman <michael@ellerman.id.au>
Cc: Jiri Slaby <jslaby@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Date: Mon, 11 Feb 2013 21:53:58 -0500
In-Reply-To: <20130212020039.GA8979@concordia>
References: <20130102153744.GC25940@redhat.com>
	 <20130118205358.GA6854@redhat.com> <20130118210728.GA16742@kroah.com>
	 <50FB0957.2000400@suse.cz> <1359570837.3325.30.camel@thor.lan>
	 <20130211024412.GA7623@concordia> <1360593750.25941.13.camel@thor.lan>
	 <20130212020039.GA8979@concordia>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3-0pjh1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-02-12 at 13:00 +1100, Michael Ellerman wrote:
> Sorry I just mean I'm seeing the warning, I have no idea how.

Ok, no problem. I just got a little excited because that area of code
was hard to test adequately.

> > Can you reproduce after using the following patch series?
> > [PATCH v3 00/23] ldisc fixes
> 
> What are they against? I tried Linus' tree and linux-next but they
> didn't apply cleanly against either.

The series was generated against next-20130204. 13/23 doesn't apply
cleanly at next-20130211 because of changes since. Rebases fine
though :)

The series is currently in mid-review, so a new series won't be out
until that completes.  (Besides, next-20130211 doesn't even boot for
me.)

Regards,
Peter Hurley

