Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752076AbaJJPzw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 11:55:52 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:48787 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312AbaJJPzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 11:55:51 -0400
MIME-Version: 1.0
Date: Fri, 10 Oct 2014 18:55:49 +0300
Message-ID: <CAGBcZGfHX57jwCfw7CnvLgOJ58kd0KVJULOvhAsfi=3YBp5WsQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] efi: Capsule update support
From: Sam Protsenko <semen.protsenko@linaro.org>
To: matt@console-pimps.org
Cc: Matt Fleming <matt.fleming@intel.com>,
        Leif Lindholm <leif.lindholm@linaro.org>, hock.leong.kweh@intel.com,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matt,

1. Why x86 code isn't separated to another patch?
2. drivers/firmware/efi/reboot.c: efi_reboot():
    One shouldn't use "printk()" with no KERN_* stuff passed into it.
I'd recommend to use "pr_info()" macro or something like that.
