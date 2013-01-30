Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753742Ab3A3HNc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 02:13:32 -0500
Received: from mail-la0-f45.google.com ([209.85.215.45]:43905 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753292Ab3A3HNa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 02:13:30 -0500
MIME-Version: 1.0
In-Reply-To: <871ud3q4sr.fsf@nemi.mork.no>
References: <1359388030-2821-1-git-send-email-dnlplm@gmail.com>
	<1359479958.1635.8.camel@dcbw.foobar.com>
	<871ud3q4sr.fsf@nemi.mork.no>
Date: Wed, 30 Jan 2013 08:13:28 +0100
Message-ID: <CAGRyCJFxe4sg_GhimQjTG+jSb8CYJRP3wGcJDEJSq6Uek0Y_iQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] USB: option: add support for Telit LE920
From: Daniele Palmas <dnlplm@gmail.com>
To: =?ISO-8859-1?Q?Bj=F8rn_Mork?= <bjorn@mork.no>
Cc: Dan Williams <dcbw@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Matthias Urlichs <smurf@smurf.noris.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

2013/1/29 Bjørn Mork <bjorn@mork.no>:
> Dan Williams <dcbw@redhat.com> writes:
>> On Mon, 2013-01-28 at 16:47 +0100, Daniele Palmas wrote:
>>> From: danielepa <danielepa@L2011.(none)>
>>>
>>> Add PID and special handling for Telit LE920
>>
>> Any idea what interfaces 1 and 5 are?  Is one perhaps a pseudo-ethernet
>> interface that could be used instead of PPP?  What's the lsusb -v output
>> for the device?
>
> Daniele has already posted a patch adding intf #5 to qmi_wwan, so I
> assume that is verified to be a QMI/rmnet interface.
>
> But I was wondering about #1 too, if that indeed is a vendor specific
> interface providing a non-serial, non-rmnet function.  What could that
> be?
>
>
> Bjørn

The output of lsusb for interface #1 is the following:

Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       0
      bNumEndpoints           2
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass     66
      bInterfaceProtocol      1
      iInterface              0

It should be an adb device, so probably it is not needed to blacklist
it. Should I resend a new patch with only interface #5 reserved?

Thanks,
Daniele
