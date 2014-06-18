Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756538AbaFRAaW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 20:30:22 -0400
Received: from g4t3426.houston.hp.com ([15.201.208.54]:34379 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753357AbaFRAaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 20:30:21 -0400
Message-ID: <1403051413.4155.12.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH v3 0/2] Fix subject line
From: Davidlohr Bueso <davidlohr@hp.com>
To: Wahib <wahibfaizi@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Valentina Manea <valentina.manea.m@gmail.com>,
        linux-usb@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Date: Tue, 17 Jun 2014 17:30:13 -0700
In-Reply-To: <CABFmzrO=LP+=HHp7xGGvoPqNxKLmWbqWApvwxPN-unAH2CZekg@mail.gmail.com>
References: <1402569338-5709-1-git-send-email-wahibfaizi@gmail.com>
	 <1402602019-12819-1-git-send-email-wahibfaizi@gmail.com>
	 <1402604734.2627.10.camel@buesod1.americas.hpqcorp.net>
	 <CABFmzrO=LP+=HHp7xGGvoPqNxKLmWbqWApvwxPN-unAH2CZekg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-06-16 at 00:28 +0400, Wahib wrote:
> Hi Davidlohr!
> 
> Don't worry. I am not discouraged. :)
> 
> I understand your concern that the patch feels superficial. It's what the task
> asked us to do. I suspect the author(s) of the Eudyptula Challenge designed
> this task to get us involved with the Linux kernel community.

If you feel you actually learn something by doing the Eudyptula
Challenge, then good for you, and by all means continue doing so. As I
mentioned, I know almost zero about it, but can say for sure that
cleanups alone won't get you very far in the community and you will
probably get bored sooner or later -- which is unfortunate as kernel
hacking fascinating.

> 
> I have been looking for a bug in 'usbip' to bundle with my patch. The only bug
> that I could find (as of 16-Jun-2014) on bugzilla.kernel.org related
> to 'usbip' is Bug 77191.
> 
> Bug 77191 - ftdi-sio (usbserial) over usbip hung after disconnect while in use
> (https://bugzilla.kernel.org/show_bug.cgi?id=77191)
> 
> Sadly the bug doesn't seem to be newbie friendly as it requires special setup
> to reproduce and requires the developer to know about the intricacies of the
> 'usbip' subsystem. I understand that people commiting their specialized
> knowledge is how the kernel development actually works. But USB is not my
> speciality (yet).
> 
> Could you point me to more beginner friendly bugs which aren't superficial code
> cleanups?

There are plenty of bugs out there, and not so hard to find -- just push
some module/filesystem/subsystem/testcase hard enough to make it do
things it shouldn't. Run linux-next on trinity and fix/report the bugs,
etc.

imho testing and reading other people's patches is perhaps the best way
to do useful things, get acquainted with the code and get experience
with lkml and the process behind kernel development.

> Can I bundle fixes to subsystems other than 'usbip' with the code cleanup patch
> for 'usbip'?

Probably not, unless it's a tree-wide change.

Hope this helps,
Davidlohr

