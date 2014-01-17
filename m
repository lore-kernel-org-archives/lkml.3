Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752038AbaAQI4k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 03:56:40 -0500
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:50870 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751064AbaAQI4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 03:56:38 -0500
X-Greylist: delayed 460 seconds by postgrey-1.27 at vger.kernel.org; Fri, 17 Jan 2014 03:56:37 EST
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1401162249150.23018@pobox.suse.cz>
References: <1389219529-29671-1-git-send-email-benjamin.tissoires@redhat.com>
 <1389219529-29671-2-git-send-email-benjamin.tissoires@redhat.com> <alpine.LNX.2.00.1401162249150.23018@pobox.suse.cz>
From: Nestor Lopez Casado <nlopezcasad@logitech.com>
Date: Fri, 17 Jan 2014 09:48:26 +0100
Message-ID: <CAE7qMrpEKYesrcHkhTYxCCOW3TRA7P8SOX9brj83zqY7y=3_3g@mail.gmail.com>
Subject: Re: [PATCH 1/5] HID: logitech-dj: Fix USB 3.0 issue
To: Jiri Kosina <jkosina@suse.cz>
Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Andrew de los Reyes <adlr@chromium.org>,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 16, 2014 at 10:50 PM, Jiri Kosina <jkosina@suse.cz> wrote:
> On Wed, 8 Jan 2014, Benjamin Tissoires wrote:
>
>> From: Benjamin Tisssoires <benjamin.tissoires@redhat.com>
>>
>> This fix (not very clean though) should fix the long time USB3
>> issue that was spotted last year. The rational has been given by
>> Hans de Goede:
>
> Man this is so ugly ... makes one wonder how come that other OSes don't
> suffer from this. Are they really *that much* slower? :)
>
> I have applied this (and just this) one for 3.14.

This is clearly a workaround for an underlying bug.
Most probably the issue is in the receiver firmware, and the bug
happens to become apparent easier when it is plugged in a usb 3.0
port.
We are experiencing some issues when the receiver is plugged to usb
3.0 ports in other OSes as well, these could also be explained by the
same phenomenon of vendor requests being missed by the receiver. But
we dont have a clear understanding of the problem yet.

>
> Thanks,
>
> --
> Jiri Kosina
> SUSE Labs
Cheers,
-nestor
