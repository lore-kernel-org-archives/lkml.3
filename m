Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932644Ab3DYP5L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 11:57:11 -0400
Received: from mail-qe0-f45.google.com ([209.85.128.45]:51831 "EHLO
	mail-qe0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932087Ab3DYP5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 11:57:08 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <Pine.LNX.4.44L0.1304251145110.948-100000@iolanthe.rowland.org>
References: <CA+icZUX96ADfV5rxce+2t4J870BvZTPGOCCSgVcJ8_Hc2RMxeg@mail.gmail.com>
	<Pine.LNX.4.44L0.1304251145110.948-100000@iolanthe.rowland.org>
Date: Thu, 25 Apr 2013 17:57:07 +0200
Message-ID: <CA+icZUVUd=0oFhPt8Gneze1UyZ5vyGxoEDnBNrya0+mn99nQkA@mail.gmail.com>
Subject: Re: linux-next: Tree for Apr 24 [ PM: Device 1-1.2 failed to resume
 async: error -32 ]
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Linux PM List <linux-pm@lists.linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-usb@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 25, 2013 at 5:49 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Thu, 25 Apr 2013, Sedat Dilek wrote:
>
>> [ Run logging on USB-bus #1 ]
>>
>> # cat /sys/kernel/debug/usb/usbmon/1u > /tmp/usbmon-1u.txt <--- USB-bus #01
>>
>> [ Do suspend plus resume ]
>>
>> ...
>>
>> [ Check /tmp/usbmon-1u.txt file ]
>>
>> ...
>>
>> File attached!
>
> That also looks normal.  Did you have CONFIG_USB_DEBUG enabled during
> this test?  If you did, you could try turning it back off to see if the
> original problem returns while still doing a usbmon trace.
>

As my system works as "expected" after suspend-resume and as you
pointed out "this is harmless" I am not really willing to do more
"homework".

The ipc-sem-next issue has stolen quite bit of my time.

Thanks for the usbmon hint, now I know for next USB issues what to do.
And I have never tried my USB-XHCI interface :-).

/me is just an encouraged Linux-kernel hobbyist.

- Sedat -

> Alan Stern
>
