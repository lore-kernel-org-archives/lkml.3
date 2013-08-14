Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752917Ab3HNGqt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 02:46:49 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:34492 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752276Ab3HNGqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 02:46:47 -0400
Message-ID: <520B27C1.4090803@ahsoftware.de>
Date: Wed, 14 Aug 2013 08:46:25 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
CC: Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-input <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Subject: Re: [PATCH 1/3] HID: Use existing parser for pre-scanning the report
 descriptors
References: <1376405889-12378-1-git-send-email-benjamin.tissoires@redhat.com> <1376405889-12378-2-git-send-email-benjamin.tissoires@redhat.com> <520A7CDF.3070808@ahsoftware.de> <CAN+gG=EkGToAGatxqywBatJOjcWUF6=u1SZ86vVmUPnujJMJvw@mail.gmail.com>
In-Reply-To: <CAN+gG=EkGToAGatxqywBatJOjcWUF6=u1SZ86vVmUPnujJMJvw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 13.08.2013 21:15, schrieb Benjamin Tissoires:
> On Tue, Aug 13, 2013 at 8:37 PM, Alexander Holler <holler@ahsoftware.de> wrote:

>>
>> Another problem is that I don't have any commercial sensor hub and I'm
>> therefor not a very relvant as tester (I've implemented the firmware for my
>> HID (sensor hub) device too). Therefor I've added Srinivas Pandruvada to cc,
>> because he's the only one I know who has HID sensor hubs.
>
> It is not a problem if you don't have a commercial sensor hub :)
> Thanks for adding Srinivas in CC.

The problem is that this invalidates me as a tester because everything I 
can test is something untested. As I've written both ends of the pipe, I 
could have understood something totally wrong but as I've implemented 
both sides (the device- and the kernel-part) it still might work without 
problems. Therefor I currently have to bother Srinivas whenever I do 
changes in the kernel in regard to hid-sensor-hub. ;)

>>
>> And, as said, I've implemented the other side here too, therefor I've added
>> the descriptor I'm using below.
>>
>
> Thanks, this will help me to test against your report descriptors.
> Can I also ask you to send me some hid-recorder[1] traces of your
> sensor? With hid-replay, I can then re-inject them in the hid
> subsystem, and then I include the results in a regression test suite.

Unfortunately hid-record doesn't list my device because it doesn't show 
up as an hidraw-device.

But maybe you have an Arduino Leonardo or a clone. If so you can get the 
description and firmware here:

http://ahsoftware.de/dcf77-hid-usb-rtc/

Regards,

Alexander Holler

