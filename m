Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750805AbaCFHaJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 02:30:09 -0500
Received: from mail-wg0-f47.google.com ([74.125.82.47]:43347 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859AbaCFHaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 02:30:08 -0500
MIME-Version: 1.0
In-Reply-To: <CABdoFFdXzRE7wnkmwFo7Dt6vzM8KtunGo-vtOTTszekDfAOMVA@mail.gmail.com>
References: <1393960599-21379-1-git-send-email-valentina.manea.m@gmail.com>
	<20140304192014.GA28665@kroah.com>
	<CABdoFFdXzRE7wnkmwFo7Dt6vzM8KtunGo-vtOTTszekDfAOMVA@mail.gmail.com>
Date: Wed, 5 Mar 2014 23:30:06 -0800
Message-ID: <CABwEGXhH6AHO+qcNkq7qsMncJLUhS8YoK4koN9oJKeoF4uXuGw@mail.gmail.com>
Subject: Re: [PATCH] staging: usbip: userspace: increase version to 2.0
From: Andrew Grover <andy.grover@gmail.com>
To: Valentina Manea <valentina.manea.m@gmail.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, devel@driverdev.osuosl.org,
        shuah.kh@samsung.com, linux-usb@vger.kernel.org,
        ly80toro@cip.cs.fau.de, tobias.polzer@fau.de,
        linux-kernel@vger.kernel.org,
        "Linux Kernel Community @ ROSEdu" <firefly@lists.rosedu.org>,
        dominik.paulus@fau.de, ihadzic@research.bell-labs.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 5, 2014 at 10:14 PM, Valentina Manea
<valentina.manea.m@gmail.com> wrote:
> On Tue, Mar 4, 2014 at 9:20 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
>> On Tue, Mar 04, 2014 at 09:16:39PM +0200, Valentina Manea wrote:
>>> -AC_INIT([usbip-utils], [1.1.1], [linux-usb@vger.kernel.org])
>>> +AC_INIT([usbip-utils], [2.0], [linux-usb@vger.kernel.org])
>>
>> Why?
>>
>> What does this mean?  What warrents the version change?  Why have a
>> version at all?
>
> This was part of an effort to "refresh" USB/IP by moving userspace out
> of kernel.git.
> Since some major changes have been made (libudev migration), Andy (cc'ed) and me
> thought it was worth to be promoted to version 2.0.

(sorry, resending in plain text mode so vger doesn't bounce (curse you
gmail :-))

Valentina did considerable work in moving usbip-utils from using the
defunct libsysfs to libudev (well, part of systemd now it seems.) so
some version bump seems appropriate, why not to 2.0? esp. as a
heads-up to pkg maintainers - btw usbip-utils is already packaged for
Debian, and I could probably see it in Fedora too, why not.

As to why have a version at all, this is of course tied to whether
usbip-utils will ever emerge from the belly of the whale and return to
its own home. I think it should someday, if the concerns about
long-term maintenance and interface stability can be addressed to your
satisfaction. It would be considerable work to integrate it into the
kernel build, and would need to be undone if it ever left kernel.git.

Regards -- Andy
