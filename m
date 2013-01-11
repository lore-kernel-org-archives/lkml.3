Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753815Ab3AKOKc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 09:10:32 -0500
Received: from mail-we0-f177.google.com ([74.125.82.177]:55687 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752103Ab3AKOKb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 09:10:31 -0500
MIME-Version: 1.0
In-Reply-To: <20130111134118.GB19224@kroah.com>
References: <CAFub=KQK9Qm1vDAetJc53O+mTZCgnaGDw9hYgeSZ76KCX_XSyQ@mail.gmail.com>
	<20130111134118.GB19224@kroah.com>
Date: Fri, 11 Jan 2013 16:10:30 +0200
Message-ID: <CAFub=KQuD_pBE-6yPV8dQOkbPC6ndi+6gO+MDJW+6iEPjZNBRw@mail.gmail.com>
Subject: Re: Kernel driver vs libusb performance
From: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozancag@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Ah, my sympathies, USB on a rpi is horrible, and you will have all sorts
> of nasty issues, no matter how you end up doing this (in the kernel or
> userspace).

What kind of issues? Currently I can read from the device without
problem. But, I had very weird problems with 2 uvc cameras, you're
right.

> Test it out and see.  I really don't think that user vs. kernel space is
> going to be the issue here, I think you are going to see some very real
> problems with the hardware itself in this area.
>
> Best of luck,

Well If I were you I would probably write that simple driver in a few
hours but seen that I am not you, I wanted to learn will the effort
worth the result :)

Anyway, thanks!

-- 
Ozan Çağlayan
Research Assistant
Galatasaray University - Computer Engineering Dept.
http://www.ozancaglayan.com
