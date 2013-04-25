Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932634Ab3DYPwl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 11:52:41 -0400
Received: from mail-qe0-f42.google.com ([209.85.128.42]:62976 "EHLO
	mail-qe0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932217Ab3DYPwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 11:52:39 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <Pine.LNX.4.44L0.1304251135540.948-100000@iolanthe.rowland.org>
References: <CA+icZUVBbFPYXQRG6C7RN00NPXqwsq7Jy=Gj8udA97utiCd=ZA@mail.gmail.com>
	<Pine.LNX.4.44L0.1304251135540.948-100000@iolanthe.rowland.org>
Date: Thu, 25 Apr 2013 17:52:38 +0200
Message-ID: <CA+icZUWac2ETFFhbv3eaft1JfZYt-qvYbNDdOF6eDK6akqGABw@mail.gmail.com>
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

On Thu, Apr 25, 2013 at 5:44 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Wed, 24 Apr 2013, Sedat Dilek wrote:
>
>> With CONFIG_USB_DEBUG=y I do not see a PM/async line.
>>
>> Might you have a look at the logs?
>
> They look quite normal.  Except for one thing: The built-in hubs appear
> to have gotten reset during the suspend/resume, for no apparent reason.
> That's probably the reason why the Logitech mouse needed a reset.
>
> I don't know why the mouse reset worked this time but not before,
> unless it's a subtle timing issue (the extra debugging output causes
> the resume to go a little more slowly).
>

Thanks for your patience, help, hints and explanations.

You want me to send a patch against usb-next to clarify a bit on the
kernel-config options to be enabled as prereqs in case of
usbmon-tracing. If you think it's worth or not let me know.

- Sedat -

> Alan Stern
>
