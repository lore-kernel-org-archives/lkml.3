Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756414Ab3BGKJ5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 05:09:57 -0500
Received: from mail-ie0-f179.google.com ([209.85.223.179]:52945 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754955Ab3BGKJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 05:09:55 -0500
MIME-Version: 1.0
In-Reply-To: <5112FC44.2000303@linux.intel.com>
References: <5112FC44.2000303@linux.intel.com>
Date: Thu, 7 Feb 2013 11:09:54 +0100
Message-ID: <CACRpkdacYOeG2tqSW5YhqbkxGnxCxamAc_UUyghEQXO98OvKJw@mail.gmail.com>
Subject: Re: gpio-sch GPIO_SYSFS access
From: Linus Walleij <linus.walleij@linaro.org>
To: Darren Hart <dvhart@linux.intel.com>
Cc: "lkml," <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Denis Turischev <denis@compulab.co.il>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 7, 2013 at 1:58 AM, Darren Hart <dvhart@linux.intel.com> wrote:

> Is it that some other driver has claimed these GPIO lines? If so, how do
> I determine which one?

Yes I think that could be it, the driver would need to call
gpio_export() for it to also be accessible in sysfs.

Configure in debugfs and check the file "gpio" in debugfs
to figure out the client.

Yours,
Linus Walleij
