Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757101Ab3IMAOS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 20:14:18 -0400
Received: from mail-bk0-f47.google.com ([209.85.214.47]:52022 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754096Ab3IMAOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 20:14:15 -0400
MIME-Version: 1.0
X-Originating-IP: [89.2.206.189]
In-Reply-To: <20130912224719.GA1154@kroah.com>
References: <1378298828-18560-1-git-send-email-teg@jklm.no> <20130912224719.GA1154@kroah.com>
From: Tom Gundersen <teg@jklm.no>
Date: Fri, 13 Sep 2013 02:13:53 +0200
Message-ID: <CAG-2HqWs3=i2G0UYoq00Wr2Kpo=7wDU5eGbPhzYVj4ayAfDiKQ@mail.gmail.com>
Subject: Re: [PATCH 1/2][usbutils] lsusb: port to hwdb
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 13, 2013 at 12:47 AM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Wed, Sep 04, 2013 at 02:47:07PM +0200, Tom Gundersen wrote:
>> Most of the information in usb.ids is now contained in udev's hwdb. Read the
>> information from the hwdb instead of usb.ids.
>>
>> This would allow distributions to no longer ship (most of) usb.ids by default,
>> but rather keep all the usb device information in the hwdb.
>>
>> This patch introduces a dependency on libusb >= 196.
>
> You mean 'libudev' here, right?  I don't think libusb has that version
> number quite yet :)

Hehe, precisely :-)

-t
