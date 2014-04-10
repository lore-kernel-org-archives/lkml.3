Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934662AbaDJGuJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 02:50:09 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:44703 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933287AbaDJGuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 02:50:06 -0400
MIME-Version: 1.0
In-Reply-To: <CA+5PVA5VBns=hkOSViucrpT340uG0=hgrWqf=LYHTBFAe74tBg@mail.gmail.com>
References: <CA+5PVA5VBns=hkOSViucrpT340uG0=hgrWqf=LYHTBFAe74tBg@mail.gmail.com>
Date: Thu, 10 Apr 2014 08:50:05 +0200
Message-ID: <CACna6ry+FOYykZpzycEjDA+ncGNLk6eXkwadXy548h9dgU1Bgw@mail.gmail.com>
Subject: Re: Oops in acpi_gpiochip_add on MacBookPro with Linux v3.14-12042-g69cd9eba3886
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Josh Boyer <jwboyer@fedoraproject.org>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-gpio@vger.kernel.org,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-04-09 23:09 GMT+02:00 Josh Boyer <jwboyer@fedoraproject.org>:
> With Linux v3.14-12042-g69cd9eba3886 I get an oops from the bcma
> module on the MacBookPro 10,2 I have here.  This works fine with Linux
> v3.14-7333-g59ecc26004e7.  There have been no changes between those
> two versions to bcma itself, but the GPIO merge did go in that window.
>  I can attempt to do a bisect tomorrow, but looking over some of the
> GPIO commits it seems pretty relevant to the ACPI GPIO changes.  I'm
> hoping someone here has an idea on what the issue might be and has
> some possible things for me to test for fixes.

Bug report: https://lkml.org/lkml/2014/3/24/262
Patch: https://lkml.org/lkml/2014/3/24/293
Tested by Sabrina: https://lkml.org/lkml/2014/3/24/304
(all links are for the same thread).

Now you simply have to find above patch in some git tree :) Not sure
if it's already in Linus's one.
