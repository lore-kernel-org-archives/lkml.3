Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966271AbaFTTqK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 15:46:10 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:65359 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965730AbaFTTqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 15:46:07 -0400
MIME-Version: 1.0
In-Reply-To: <1403250112.22857.7.camel@x220>
References: <1401825852-4745-1-git-send-email-andreas.noever@gmail.com>
 <1401825852-4745-2-git-send-email-andreas.noever@gmail.com> <1403250112.22857.7.camel@x220>
From: Andreas Noever <andreas.noever@gmail.com>
Date: Fri, 20 Jun 2014 21:45:45 +0200
Message-ID: <CAMxnaaXF4Rzg7=FA7FEJWbSvzk5HCjSbmPs57SYPye_hadiouw@mail.gmail.com>
Subject: Re: [PATCH v5 01/15] thunderbolt: Add initial cactus ridge NHI support
To: Paul Bolle <pebolle@tiscali.nl>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Matthew Garrett <matthew.garrett@nebula.com>, Greg KH <greg@kroah.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 20, 2014 at 9:41 AM, Paul Bolle <pebolle@tiscali.nl> wrote:
> On Tue, 2014-06-03 at 22:03 +0200, Andreas Noever wrote:
>> Thunderbolt hotplug is supposed to be handled by the firmware. But Apple
>> decided to implement thunderbolt at the operating system level. The
>> firmare only initializes thunderbolt devices that are present at boot
>> time. This driver enables hotplug of thunderbolt of non-chained
>> thunderbolt devices on Apple systems with a cactus ridge controller.
>>
>> This first patch adds the Kconfig file as well the parts of the driver
>> which talk directly to the hardware (that is pci device setup, interrupt
>> handling and RX/TX ring management).
>>
>> Signed-off-by: Andreas Noever <andreas.noever@gmail.com>
>> ---
>
> This patch landed in today's linux-next (next-20140620).
>
>> [...]
>> --- /dev/null
>> +++ b/drivers/thunderbolt/Kconfig
>> @@ -0,0 +1,12 @@
>> +menuconfig THUNDERBOLT
>> +     tristate "Thunderbolt support for Apple devices"
>> +     default no
>
> That should have been "default n". But "n" is the default anyway, so I'd
> say this line might as well be dropped. Should I draft the trivial patch
> to do that?

Not necessary. A patch has already been send.

Andreas
