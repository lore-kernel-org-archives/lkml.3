Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752207AbaFOU3M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 16:29:12 -0400
Received: from mail-yk0-f172.google.com ([209.85.160.172]:44480 "EHLO
	mail-yk0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176AbaFOU3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 16:29:10 -0400
MIME-Version: 1.0
In-Reply-To: <1402604734.2627.10.camel@buesod1.americas.hpqcorp.net>
References: <1402569338-5709-1-git-send-email-wahibfaizi@gmail.com>
 <1402602019-12819-1-git-send-email-wahibfaizi@gmail.com> <1402604734.2627.10.camel@buesod1.americas.hpqcorp.net>
From: Wahib <wahibfaizi@gmail.com>
Date: Mon, 16 Jun 2014 00:28:49 +0400
Message-ID: <CABFmzrO=LP+=HHp7xGGvoPqNxKLmWbqWApvwxPN-unAH2CZekg@mail.gmail.com>
Subject: Re: [PATCH v3 0/2] Fix subject line
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Valentina Manea <valentina.manea.m@gmail.com>,
        linux-usb@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Davidlohr!

Don't worry. I am not discouraged. :)

I understand your concern that the patch feels superficial. It's what the task
asked us to do. I suspect the author(s) of the Eudyptula Challenge designed
this task to get us involved with the Linux kernel community.

I have been looking for a bug in 'usbip' to bundle with my patch. The only bug
that I could find (as of 16-Jun-2014) on bugzilla.kernel.org related
to 'usbip' is Bug 77191.

Bug 77191 - ftdi-sio (usbserial) over usbip hung after disconnect while in use
(https://bugzilla.kernel.org/show_bug.cgi?id=77191)

Sadly the bug doesn't seem to be newbie friendly as it requires special setup
to reproduce and requires the developer to know about the intricacies of the
'usbip' subsystem. I understand that people commiting their specialized
knowledge is how the kernel development actually works. But USB is not my
speciality (yet).

Could you point me to more beginner friendly bugs which aren't superficial code
cleanups?

Can I bundle fixes to subsystems other than 'usbip' with the code cleanup patch
for 'usbip'?

Regards,
Wahib

On Fri, Jun 13, 2014 at 12:25 AM, Davidlohr Bueso <davidlohr@hp.com> wrote:
> On Thu, 2014-06-12 at 23:40 +0400, Wahib Faizi wrote:
>> Fix coding style issues detected by checkpatch.pl in usbip_host_driver.c.
>
> Sorry but unless bundled with something more meaningful, I really don't
> see the value in these changes. I certainly don't want to discourage
> folks or anything, but just testing other patches is a lot more helpful
> than this.
>
> I haven't followed much about the Eudyptula Challenge, but I hope other
> assignments are more involved than this.
>
> Thanks,
> Davidlohr
>
