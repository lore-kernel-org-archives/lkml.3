Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756279AbaIWPZx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 11:25:53 -0400
Received: from mail-ig0-f180.google.com ([209.85.213.180]:64996 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755942AbaIWPZv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 11:25:51 -0400
MIME-Version: 1.0
In-Reply-To: <1410868367-11056-8-git-send-email-mika.westerberg@linux.intel.com>
References: <1410868367-11056-1-git-send-email-mika.westerberg@linux.intel.com>
	<1410868367-11056-8-git-send-email-mika.westerberg@linux.intel.com>
Date: Tue, 23 Sep 2014 17:25:50 +0200
Message-ID: <CACRpkdaZJt_6cd1vtDw-Ys+YqUhNb0aXazUxGCX8mk4=6EmdHw@mail.gmail.com>
Subject: Re: [RFC PATCH v2 07/16] gpio: Add support for unified device
 properties interface
From: Linus Walleij <linus.walleij@linaro.org>
To: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Grant Likely <grant.likely@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Darren Hart <dvhart@linux.intel.com>,
        Mark Rutland <mark.rutland@arm.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, Lee Jones <lee.jones@linaro.org>,
        Aaron Lu <aaron.lu@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 16, 2014 at 1:52 PM, Mika Westerberg
<mika.westerberg@linux.intel.com> wrote:

> Some drivers need to deal with only firmware representation of its
> GPIOs. An example would be a GPIO button array driver where each button
> is described as a separate firmware node in device tree. Typically these
> child nodes do not have physical representation in the Linux device
> model.
>
> In order to help device drivers to handle such firmware child nodes we
> add dev[m]_node_get_named_gpiod() that takes a firmware node pointer as
> parameter, finds the GPIO using whatever is the underlying firmware
> method, and requests the GPIO properly.
>
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>

I have a hard time figuring out if this is what we want for common
accessors between DT and ACPI.

Can I get some input from Grant, Arnd, Mark, Darren...?

Yours,
Linus Walleij
