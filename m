Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753486Ab3FAWwF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 18:52:05 -0400
Received: from mail-oa0-f42.google.com ([209.85.219.42]:51580 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294Ab3FAWwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 18:52:03 -0400
MIME-Version: 1.0
In-Reply-To: <20130601171125.GA8824@debian>
References: <1370031778-25965-1-git-send-email-emilgoode@gmail.com>
	<CAHp75VciHQKcyj-ANLdg=mg2C71zn=09Eentf22q+otGu=rp3w@mail.gmail.com>
	<51A926A4.5010800@infradead.org>
	<CAHp75Vd3frBwPa=DQiKrkkcPdOooBGUS=tYC6STw+o1gW1zf6Q@mail.gmail.com>
	<20130601171125.GA8824@debian>
Date: Sun, 2 Jun 2013 01:52:01 +0300
Message-ID: <CAHp75Vf9NaLYQiOMAqbaFt5c60APFVT2zhTQ78DGCo=9tcs_cw@mail.gmail.com>
Subject: Re: [PATCH] usb: musb: Fix format specifier warning
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Emil Goode <emilgoode@gmail.com>
Cc: Randy Dunlap <rdunlap@infradead.org>, balbi@ti.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        USB <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 1, 2013 at 8:11 PM, Emil Goode <emilgoode@gmail.com> wrote:
> Thank's for your pointers.
> I will send a patch that applies on top of Felipe's patch.

I guess there is not much sense to do that since Felipe applied your
patch already. Just keep in mind the hint for future changes.

--
With Best Regards,
Andy Shevchenko
