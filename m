Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752019AbaHDJMh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 05:12:37 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:60349 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643AbaHDJMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 05:12:35 -0400
MIME-Version: 1.0
In-Reply-To: <1406913373.10668.5.camel@dcbw.local>
References: <1406894424-7561-1-git-send-email-ricardo.ribalda@gmail.com> <1406913373.10668.5.camel@dcbw.local>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Mon, 4 Aug 2014 11:12:14 +0200
Message-ID: <CAPybu_3rpyreJUDimeAzieB9nRYjJ-iu60fMfq3zs+SmhNyt7A@mail.gmail.com>
Subject: Re: [PATCH] serial/option: Add support for Option GTM671WFS
To: Dan Williams <dcbw@redhat.com>
Cc: Johan Hovold <johan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Dan

>
> Are you 100% sure these don't go into the 'hso' driver?  'option' is
> used for mostly older Option devices (like 5+ years old).  I tried to
> find information about this module, and the closest I could come for
> 0af0:9200 was:
>
> http://trac.gateworks.com/wiki/3g
>
> which indicates they might be 'hso' instead.  Can you give that a try?

With all the hso_ids configuration I get the following error message:

[  553.501693] hso: drivers/net/usb/hso.c: Option Wireless
[  553.524898] hso 2-1.4:1.7: Not our interface

and depending on the mode I get 3, 4 or 6 ttySH interfaces

But, if we ignore this, the device can connect to the internet with
hso_connect.sh. I have already post a patch using the hso driver.

The device could also connect with option.ko... Do you think that
there could be other devices wrongly handled with option ?

Ricardo
