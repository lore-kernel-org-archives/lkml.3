Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752191AbaDWXDk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 19:03:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17921 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751652AbaDWXDj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 19:03:39 -0400
Message-ID: <1398294208.2673.11.camel@adam.happyassassin.net>
Authentication-Results: mail.happyassassin.net; dmarc=none header.from=redhat.com
Subject: Re: [Resend Patch 0/9] I2C ACPI operation region handler support
From: Adam Williamson <awilliam@redhat.com>
To: Lan Tianyu <tianyu.lan@intel.com>
Cc: wsa@the-dreams.de, rjw@rjwysocki.net, mika.westerberg@linux.intel.com,
        lenb@kernel.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Date: Wed, 23 Apr 2014 16:03:28 -0700
In-Reply-To: <1398147855-9868-1-git-send-email-tianyu.lan@intel.com>
References: <1397654682-7094-1-git-send-email-tianyu.lan@intel.com>
	 <1398147855-9868-1-git-send-email-tianyu.lan@intel.com>
Organization: Red Hat
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-04-22 at 14:24 +0800, Lan Tianyu wrote:
> ACPI 5.0 spec(5.5.2.4.5) defines GenericSerialBus(i2c, spi, uart) operation
> region. It allows ACPI aml code able to access such kind of devices to
> implement some ACPI standard method.
> 
> On the Asus T100TA, Bios use GenericSerialBus operation region to access
> i2c device to get battery info. So battery function depends on the I2C
> operation region support. Here is the bug link.
> https://bugzilla.kernel.org/show_bug.cgi?id=69011
> 
> This patchset is to add I2C ACPI operation region handler support.

For what it's worth, I've tested this patchset with the exception of
patch 9/9 - which I leave out because it would require annoying fiddling
with my kernel builds - and it gives apparently-accurate battery/AC
information on my Venue 8 Pro.

It doesn't *obviously* cause any other problems, though there are a few
other issues I'm dealing with ATM. If any of them turn out to be related
to this patch set, I'll send a follow-up.
-- 
Adam Williamson
Fedora QA Community Monkey
IRC: adamw | Twitter: AdamW_Fedora | XMPP: adamw AT happyassassin . net
http://www.happyassassin.net

