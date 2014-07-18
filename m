Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946073AbaGRT7P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 15:59:15 -0400
Received: from mail-vc0-f169.google.com ([209.85.220.169]:45715 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422795AbaGRT7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 15:59:14 -0400
MIME-Version: 1.0
In-Reply-To: <53C96313.7060608@infradead.org>
References: <CAPDOMVjrRS1zSDwQ0KVL6-m774_gAwM8Ov4mehDvUZXjtmVrOA@mail.gmail.com>
	<53C96313.7060608@infradead.org>
Date: Fri, 18 Jul 2014 15:59:13 -0400
Message-ID: <CAPDOMVhUd+cF8PWmWJOEsuCdDuON5_KpO-pZA-aT4n351FgOWg@mail.gmail.com>
Subject: Re: Build Errors when building usb directory
From: Nick Krause <xerofoify@gmail.com>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Greg KH <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2014 at 2:10 PM, Randy Dunlap <rdunlap@infradead.org> wrote:
> On 07/18/2014 10:45 AM, Nick Krause wrote:
>> Hey Greg and others,
>> When I built the usb directory today to check a patch I am also
>> sending to. I seem to hitting
>> a few compiler errors and a lot of warnings.  I am going to attach a
>> file of my log of this build.
>> Cheers Nick
>>
>
> Hi,
>
> What command(s) did you use to build the usb directory?
>
> thanks,
> --
> ~Randy
I used make M=drivers/usb to build it.
Cheers Nick
